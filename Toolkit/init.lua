assert(hs.processInfo.bundleID == "dev.local.DesktopToolkit", "Unexpected runtime Bundle ID")
assert(hs.settings.bundleID == "dev.local.DesktopToolkit", "Unexpected settings domain")
assert(not hs.configdir:find(".hammerspoon", 1, true), "Personal configuration detected")
local root = hs.processInfo.bundlePath .. "/Contents/Resources/Toolkit/"
package.path = root .. "?.lua;" .. package.path
local preferences = require("modules.preferences")
local windows = require("modules.windows")
local input = require("modules.input_method")
input.start()
local clipboard = require("modules.clipboard")
local system = require("modules.sys_info")
local browser = require("modules.browser")
browser.start()
clipboard.start()
local app = {bindings={}}
_G.desktopToolkit = app
local key = "desktoptoolkit.preferences.v1"
app.config = preferences.validate(hs.settings.get(key)) or preferences.defaults()
local popupKey = "desktoptoolkit.clipboard.shortcut.v1"
local function normalizePopup(value)
    local config, message = preferences.validate({enabled=false,shortcuts={left=value}})
    if not config then return nil, message end
    return config.shortcuts.left
end
local function sameShortcut(a, b)
    return a and b and a.key==b.key and table.concat(a.mods,"+")==table.concat(b.mods,"+")
end
local function popupConflicts(shortcut, config)
    for _, action in ipairs(windows.actions) do
        if sameShortcut(shortcut, config.shortcuts[action]) then return true end
    end
    return false
end
app.popupShortcut = normalizePopup(hs.settings.get(popupKey))
local function installPopup(shortcut)
    if app.popupBinding then app.popupBinding:delete();app.popupBinding=nil end
    if not shortcut then return true end
    if hs.hotkey.systemAssigned(shortcut.mods,shortcut.key) or not hs.hotkey.assignable(shortcut.mods,shortcut.key) then return false,"剪贴板快捷键被系统占用或无法注册" end
    app.popupBinding = hs.hotkey.bind(shortcut.mods,shortcut.key,clipboard.showPopup)
    if not app.popupBinding then return false,"剪贴板快捷键注册失败" end
    return true
end
function app.savePopup(value)
    local shortcut, message = normalizePopup(value)
    if message then return false,message end
    if popupConflicts(shortcut, app.config) then return false,"剪贴板快捷键与窗口管理配置重复" end
    if not (sameShortcut(shortcut, app.popupShortcut) and app.popupBinding) then
        local success, result = installPopup(shortcut)
        if not success then
            local restored = installPopup(app.popupShortcut)
            return false, restored and result or result.."；旧快捷键也无法恢复，请重新配置"
        end
    end
    app.popupShortcut=shortcut
    if shortcut then hs.settings.set(popupKey,shortcut) else hs.settings.clear(popupKey) end
    return true, shortcut and "剪贴板菜单快捷键已保存" or "剪贴板菜单快捷键已解除"
end
local function clearBindings()
    for _, binding in ipairs(app.bindings) do binding:delete() end
    app.bindings = {}
end
local function install(config)
    if not config.enabled then return true end
    for _, action in ipairs(windows.actions) do
        local item = config.shortcuts[action]
        if item then
            if not hs.hotkey.assignable(item.mods, item.key) or hs.hotkey.systemAssigned(item.mods, item.key) then clearBindings(); return false, "快捷键被系统占用：" .. item.key end
            local binding = hs.hotkey.bind(item.mods, item.key, function()
                local ok, message = windows.run(action)
                if not ok then hs.alert.show(message) end
            end)
            if not binding then clearBindings(); return false, "无法注册快捷键：" .. item.key end
            table.insert(app.bindings, binding)
        end
    end
    return true
end
function app.save(value)
    local config, message = preferences.validate(value)
    if not config then return false, message end
    if popupConflicts(app.popupShortcut, config) then return false,"窗口快捷键与剪贴板菜单配置重复" end
    if config.enabled and not hs.accessibilityState() then return false, "请先在系统设置开启 DesktopToolkit 的辅助功能权限" end
    clearBindings()
    local ok, errorMessage = install(config)
    if not ok then install(app.config); return false, errorMessage end
    app.config = config
    hs.settings.set(key, config)
    return true, "已保存"
end
local ok, message = install(app.config)
if not ok then hs.alert.show(message) end
local function reply(ok, message)
    if app.settings then app.settings:evaluateJavaScript("window.receive(" .. hs.json.encode({ok=ok,message=message,config=app.config,input=input.config,sources=input.sources(),clipboard=clipboard.snapshot(),popupShortcut=app.popupShortcut or false,system=system.config,browser=browser.config,browsers=browser.installed(),accessibility=hs.accessibilityState()}) .. ")") end
end
function app.openSettings(section, focus)
    section=type(section)=="string" and section or nil
    focus=type(focus)=="string" and focus or nil
    app.settingsSection=section
    app.settingsFocus=focus
    if app.settings then app.settings:show():bringToFront(true); reply(true, ""); if section then app.settings:evaluateJavaScript("window.showSection(" .. hs.json.encode({section}) .. "[0])") end; if focus then app.settings:evaluateJavaScript("document.getElementById("..hs.json.encode({focus}).."[0]).focus()") end; return end
    app.controller = hs.webview.usercontent.new("toolkit")
    app.controller:setCallback(function(event)
        local body = event.body
        if type(body) ~= "table" then return end
        if body.action == "load" then
            reply(true, "")
            if app.settingsSection then app.settings:evaluateJavaScript("window.showSection(" .. hs.json.encode({app.settingsSection}) .. "[0])") end
            if app.settingsFocus then app.settings:evaluateJavaScript("document.getElementById("..hs.json.encode({app.settingsFocus}).."[0]).focus()") end
        end
        if body.action == "save" then local success, result = app.save(body.config); reply(success, result) end
        if body.action == "savePopup" then local success, result = app.savePopup(body.config); reply(success, result) end
        if body.action == "saveBrowser" then local success, result = browser.save(body.config); reply(success, result) end
        if body.action == "openBrowserURL" then local success, result = browser.open(body.url,body.sourceBundle); reply(success, result) end
        if body.action == "testBrowserURL" then local selected, result = browser.resolve(body.url,body.sourceBundle); reply(selected~=nil,selected and "将打开："..selected or result) end
        if body.action == "saveSystem" then local success, result = system.save(body.config); reply(success, result) end
        if body.action == "saveInput" then local success, result = input.save(body.config); reply(success, result) end
        if body.action == "saveClipboard" then local success, result = clipboard.save(body.config); reply(success, result) end
        if body.action == "pauseClipboard" then local success, result = clipboard.pause(); reply(success, result) end
        if body.action == "refreshClipboard" then reply(true, "") end
        if body.action == "previewClipboard" then
            local value, result = clipboard.preview(body.id)
            if value then app.settings:evaluateJavaScript("window.showImage("..hs.json.encode(value)..")") else reply(false,result) end
        end
        if body.action == "copyClipboard" then local success, result = clipboard.copy(body.id); reply(success, result) end
        if body.action == "clearClipboard" then local success, result = clipboard.clear(); reply(success, result) end
        if body.action == "chooseApp" or body.action == "chooseBrowserApp" then
            local prompt=body.action=="chooseBrowserApp" and "选择链接来源应用" or "选择要配置输入法的应用"
            local paths = hs.dialog.chooseFileOrFolder(prompt, "/Applications", true, false, false, {"app"}, true)
            local path = paths
            if type(paths)=="table" then path=paths[1] or paths["1"] end
            if type(path)=="string" and path ~= "" then
                local info = hs.application.infoForBundlePath(path)
                if info and info.CFBundleIdentifier then
                    local value = {bundleID=info.CFBundleIdentifier,name=info.CFBundleDisplayName or info.CFBundleName or info.CFBundleIdentifier}
                    local callback=body.action=="chooseBrowserApp" and "window.addBrowserAppRule(" or "window.addInputRule("
                    app.settings:evaluateJavaScript(callback .. hs.json.encode(value) .. ")")
                else reply(false, "无法识别所选应用") end
            end
        end
    end)
    local file = assert(io.open(root .. "settings.html", "r"))
    local html = file:read("*a"); file:close()
    app.settings = hs.webview.new({x=180,y=160,w=980,h=720}, {}, app.controller)
        :windowStyle({"titled","closable","resizable"}):windowTitle("DesktopToolkit 设置")
        :transparent(false):allowTextEntry(true):html(html):show():bringToFront(true)
end
clipboard.startMenu(function(mode)
    local id=mode=="settings" and "clipEnabled" or "clipSearch"
    app.openSettings("clipSection",id)
end)
if popupConflicts(app.popupShortcut, app.config) then
    hs.alert.show("剪贴板菜单快捷键与窗口配置冲突，未启用菜单绑定")
else
    local installed, errorMessage = installPopup(app.popupShortcut)
    if not installed then hs.alert.show(errorMessage) end
end
system.start(function() app.openSettings("systemSection") end)
app.menu = hs.menubar.new():setTitle("DT"):setTooltip("DesktopToolkit")
app.menu:setMenu({{title="设置…",fn=app.openSettings},{title="退出 DesktopToolkit",fn=function() os.exit() end}})
print("DesktopToolkit ready", hs.configdir, hs.settings.bundleID, "bindings", #app.bindings)
