assert(hs.processInfo.bundleID == "dev.local.DesktopToolkit", "Unexpected runtime Bundle ID")
assert(hs.settings.bundleID == "dev.local.DesktopToolkit", "Unexpected settings domain")
assert(not hs.configdir:find(".hammerspoon", 1, true), "Personal configuration detected")
local root = hs.processInfo.bundlePath .. "/Contents/Resources/Toolkit/"
package.path = root .. "?.lua;" .. package.path
local preferences = require("modules.preferences")
local windows = require("modules.windows")
local input = require("modules.input_method")
input.start()
local app = {bindings={}}
_G.desktopToolkit = app
local key = "desktoptoolkit.preferences.v1"
app.config = preferences.validate(hs.settings.get(key)) or preferences.defaults()
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
    if app.settings then app.settings:evaluateJavaScript("window.receive(" .. hs.json.encode({ok=ok,message=message,config=app.config,input=input.config,sources=input.sources(),accessibility=hs.accessibilityState()}) .. ")") end
end
function app.openSettings()
    if app.settings then app.settings:show():bringToFront(true); reply(true, ""); return end
    app.controller = hs.webview.usercontent.new("toolkit")
    app.controller:setCallback(function(event)
        local body = event.body
        if type(body) ~= "table" then return end
        if body.action == "load" then reply(true, "") end
        if body.action == "save" then local success, result = app.save(body.config); reply(success, result) end
        if body.action == "saveInput" then local success, result = input.save(body.config); reply(success, result) end
        if body.action == "chooseApp" then
            local paths = hs.dialog.chooseFileOrFolder("选择要配置输入法的应用", "/Applications", true, false, false, {"app"}, true)
            local path = paths
            if type(paths)=="table" then path=paths[1] or paths["1"] end
            if type(path)=="string" and path ~= "" then
                local info = hs.application.infoForBundlePath(path)
                if info and info.CFBundleIdentifier then
                    local value = {bundleID=info.CFBundleIdentifier,name=info.CFBundleDisplayName or info.CFBundleName or info.CFBundleIdentifier}
                    app.settings:evaluateJavaScript("window.addInputRule(" .. hs.json.encode(value) .. ")")
                else reply(false, "无法识别所选应用") end
            end
        end
    end)
    local file = assert(io.open(root .. "settings.html", "r"))
    local html = file:read("*a"); file:close()
    app.settings = hs.webview.new({x=180,y=160,w=720,h=580}, {}, app.controller)
        :windowStyle({"titled","closable","resizable"}):windowTitle("DesktopToolkit 设置")
        :allowTextEntry(true):html(html):show():bringToFront(true)
end
app.menu = hs.menubar.new():setTitle("DT"):setTooltip("DesktopToolkit")
app.menu:setMenu({{title="设置…",fn=app.openSettings},{title="退出 DesktopToolkit",fn=function() os.exit() end}})
print("DesktopToolkit ready", hs.configdir, hs.settings.bundleID, "bindings", #app.bindings)
