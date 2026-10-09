assert(hs.processInfo.bundleID == "dev.local.DesktopToolkit", "Unexpected runtime Bundle ID")
assert(hs.settings.bundleID == "dev.local.DesktopToolkit", "Unexpected settings domain")
assert(not hs.configdir:find(".hammerspoon", 1, true), "Personal configuration detected")
local root = hs.processInfo.bundlePath .. "/Contents/Resources/Toolkit/"
package.path = root .. "?.lua;" .. package.path
local i18n = require("modules.i18n")
local preferences = require("modules.preferences")
local windows = require("modules.windows")
local input = require("modules.input_method")
input.start()
local clipboard = require("modules.clipboard")
local system = require("modules.sys_info")
local browser = require("modules.browser")
browser.start()
clipboard.start()
local launcher=require("modules.launcher")
local app = {bindings={}}
local generalKey = "desktoptoolkit.general.v1"
local function validateGeneral(value)
    if type(value) ~= "table" or type(value.showMenu) ~= "boolean" or
        (value.appearance ~= "system" and value.appearance ~= "light" and value.appearance ~= "dark") then
        return nil, i18n.t("通用设置格式无效")
    end
    local language=value.language or "system"
    if language~="system" and language~="zh-Hans" and language~="en" then return nil,i18n.t("语言设置无效") end
    return {showMenu=value.showMenu, appearance=value.appearance,language=language}
end
app.general = validateGeneral(hs.settings.get(generalKey)) or {showMenu=true,appearance="system",language="system"}
-- The upstream hammer menu duplicates our own settings entry.
hs.menuIcon(false)
hs.openConsoleOnDockClick(false)
hs.nivletAppearance(app.general.appearance)
function app.saveGeneral(value)
    local config, message = validateGeneral(value)
    if not config then return false, message end
    hs.nivletAppearance(config.appearance)
    if config.showMenu then app.menu:returnToMenuBar() else app.menu:removeFromMenuBar() end
    app.general=config
    i18n.configure(config.language)
    if app.updateMenu then app.updateMenu() end
    if app.settings then app.settings:windowTitle(i18n.t("Nivlet 设置")) end
    clipboard.menu:setTooltip(i18n.t("Nivlet 剪贴板历史"))
    system.menu:setTooltip(i18n.t("Nivlet 系统信息")):setMenu(nil):setMenu(system.menuItems)
    hs.settings.set(generalKey,config)
    return true, i18n.t("通用设置已保存")
end
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
    if hs.hotkey.systemAssigned(shortcut.mods,shortcut.key) or not hs.hotkey.assignable(shortcut.mods,shortcut.key) then return false,i18n.t("剪贴板快捷键被系统占用或无法注册") end
    app.popupBinding = hs.hotkey.bind(shortcut.mods,shortcut.key,clipboard.showPopup)
    if not app.popupBinding then return false,i18n.t("剪贴板快捷键注册失败") end
    return true
end
function app.savePopup(value)
    local shortcut, message = normalizePopup(value)
    if message then return false,message end
    if launcher.conflicts(shortcut) then return false,i18n.t("快捷键与应用启动配置重复") end
    if popupConflicts(shortcut, app.config) then return false,i18n.t("剪贴板快捷键与窗口管理配置重复") end
    if not (sameShortcut(shortcut, app.popupShortcut) and app.popupBinding) then
        local success, result = installPopup(shortcut)
        if not success then
            local restored = installPopup(app.popupShortcut)
            return false, restored and result or result..i18n.t("；旧快捷键也无法恢复，请重新配置")
        end
    end
    app.popupShortcut=shortcut
    if shortcut then hs.settings.set(popupKey,shortcut) else hs.settings.clear(popupKey) end
    return true, shortcut and i18n.t("剪贴板菜单快捷键已保存") or i18n.t("剪贴板菜单快捷键已解除")
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
            if not hs.hotkey.assignable(item.mods, item.key) or hs.hotkey.systemAssigned(item.mods, item.key) then clearBindings(); return false, i18n.t("快捷键被系统占用：") .. item.key end
            local binding = hs.hotkey.bind(item.mods, item.key, function()
                local ok, message = windows.run(action)
                if not ok then hs.alert.show(message) end
            end)
            if not binding then clearBindings(); return false, i18n.t("无法注册快捷键：") .. item.key end
            table.insert(app.bindings, binding)
        end
    end
    return true
end
function app.save(value)
    local config, message = preferences.validate(value)
    if not config then return false, message end
    for _,shortcut in pairs(config.shortcuts) do if launcher.conflicts(shortcut) then return false,i18n.t("快捷键与应用启动配置重复") end end
    if popupConflicts(app.popupShortcut, config) then return false,i18n.t("窗口快捷键与剪贴板菜单配置重复") end
    if config.enabled and not hs.accessibilityState() then return false, i18n.t("请先在系统设置开启 Nivlet 的辅助功能权限") end
    clearBindings()
    local ok, errorMessage = install(config)
    if not ok then install(app.config); return false, errorMessage end
    app.config = config
    hs.settings.set(key, config)
    return true, i18n.t("已保存")
end
local ok, message = install(app.config)
if not ok then hs.alert.show(message) end
local configuration=require("modules.configuration")
local adapters={
    general={get=function() return app.general end,defaults=function() return {showMenu=true,appearance="system",language="system"} end,validate=validateGeneral,save=app.saveGeneral},
    windows={get=function() return app.config end,defaults=preferences.defaults,validate=preferences.validate,save=app.save},
    popupShortcut={get=function() return app.popupShortcut or false end,defaults=function() return false end,validate=function(v) local item,message;if v~=false then item,message=normalizePopup(v) end;if message then return nil,message end;return item or false end,save=function(v) if v==false then return app.savePopup(nil) end;return app.savePopup(v) end},
}
for name,module in pairs({input=input,clipboard=clipboard,system=system,browser=browser,launcher=launcher}) do
    adapters[name]={get=function() return module.config end,defaults=module.defaults or function() return {enabled=false,rules={}} end,validate=module.validate,save=module.save}
end
local configKeys={general=generalKey,windows=key,popupShortcut=popupKey,input="desktoptoolkit.input.v1",clipboard="desktoptoolkit.clipboard.v1",system="desktoptoolkit.system.v1",browser="desktoptoolkit.browser.v1",launcher="desktoptoolkit.launcher.v1"}
app.configuration=configuration.new(adapters,{
    systemAssigned=function(item) return hs.hotkey.systemAssigned(item.mods,item.key) end,
    accessibility=hs.accessibilityState,
    hasHistory=function() return #clipboard.entries>0 end,
    capture=function() local result={};for name,k in pairs(configKeys) do result[name]={value=hs.settings.get(k)} end;return result end,
    restore=function(saved) for name,k in pairs(configKeys) do if saved[name].value==nil then hs.settings.clear(k) else hs.settings.set(k,saved[name].value) end end end,
    available=function(config,selected)
        local function installed(id) return hs.application.pathForBundleID(id)~=nil end
        for _,name in ipairs({"launcher","input"}) do
            if selected[name] then for _,rule in ipairs(config[name].rules) do if not installed(rule.bundleID) then return false,i18n.t("应用不可用，请重新选择：")..rule.bundleID end end end
        end
        if selected.input then
            local available={};for _,source in ipairs(input.sources()) do available[source.id]=true end
            for _,rule in ipairs(config.input.rules) do if not available[rule.sourceID] then return false,i18n.t("输入法不可用，请重新选择：")..rule.sourceID end end
        end
        if selected.browser then
            if not installed(config.browser.defaultBrowser) then return false,i18n.t("默认打开浏览器未安装") end
            for _,rule in ipairs(config.browser.rules) do if not installed(rule.browser) then return false,i18n.t("规则中的浏览器未安装") end end
            for _,rule in ipairs(config.browser.appRules) do if not installed(rule.bundleID) or not installed(rule.browser) then return false,i18n.t("来源应用或浏览器未安装") end end
        end
        return true
    end,
})
local function selectedPath(paths) return type(paths)=="table" and (paths[1] or paths["1"]) or paths end
local function exportConfiguration(defaults)
    local path=selectedPath(hs.dialog.chooseFileOrFolder(i18n.t("选择配置导出文件夹"),os.getenv("HOME"),false,true,false,{},true))
    if type(path)~="string" or path=="" then return nil end
    local filename=path.."/Nivlet-"..(defaults and "defaults-" or "config-")..os.date("%Y%m%d-%H%M%S")..".json"
    if hs.fs.attributes(filename) then return false,i18n.t("目标文件已存在，请稍后重试") end
    local file,message=io.open(filename,"w")
    if not file then return false,i18n.t("无法写入配置文件：")..tostring(message) end
    local ok,result=file:write(hs.json.encode(app.configuration.export(defaults),true))
    local closed,closeMessage=file:close()
    if not ok or not closed then return false,i18n.t("无法写入配置文件：")..tostring(result or closeMessage) end
    return true,i18n.t("配置已导出：")..filename
end
local function reply(ok, message, action)
    if app.settings then app.settings:evaluateJavaScript("window.receive(" .. hs.json.encode({ok=ok,message=message,action=action,language=i18n.language(),translations=i18n.dictionary,general=app.general,launcher=launcher.config,config=app.config,input=input.config,sources=input.sources(),clipboard=clipboard.snapshot(),popupShortcut=app.popupShortcut or false,system=system.config,browser=browser.config,browsers=browser.installed(),accessibility=hs.accessibilityState()}) .. ")") end
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
            reply(true, "", "load")
            if app.settingsSection then app.settings:evaluateJavaScript("window.showSection(" .. hs.json.encode({app.settingsSection}) .. "[0])") end
            if app.settingsFocus then app.settings:evaluateJavaScript("document.getElementById("..hs.json.encode({app.settingsFocus}).."[0]).focus()") end
        end
        if body.action=="exportConfiguration" or body.action=="exportDefaults" then
            local success,result=exportConfiguration(body.action=="exportDefaults")
            if success~=nil then reply(success,result,body.action) end
        end
        if body.action=="chooseConfiguration" then
            app.pendingConfiguration=nil
            app.settings:evaluateJavaScript("window.previewConfiguration(null)")
            local path=selectedPath(hs.dialog.chooseFileOrFolder(i18n.t("选择 JSON 配置文件"),os.getenv("HOME"),true,false,false,{"json"},true))
            if type(path)=="string" and path~="" then
                local file=io.open(path,"r")
                if not file then reply(false,i18n.t("无法读取配置文件"),body.action);return end
                local text=file:read(1048577);file:close()
                if not text or #text>1048576 then reply(false,i18n.t("配置文件不得超过 1 MB"),body.action);return end
                local decoded,document=pcall(hs.json.decode,text)
                if not decoded or type(document)~="table" then reply(false,i18n.t("JSON 格式无效"),body.action);return end
                local plan,result=app.configuration.prepare(document)
                if not plan then reply(false,result,body.action);return end
                app.pendingConfiguration=document
                app.settings:evaluateJavaScript("window.previewConfiguration("..hs.json.encode(document)..")")
                reply(true,i18n.t("请核对将替换的模块，再确认导入"),body.action)
            end
        end
        if body.action=="cancelConfiguration" then app.pendingConfiguration=nil;app.settings:evaluateJavaScript("window.previewConfiguration(null)") end
        if body.action=="applyConfiguration" and app.pendingConfiguration then
            local success,result,selected=app.configuration.apply(app.pendingConfiguration)
            if success then
                app.pendingConfiguration=nil
                app.settings:evaluateJavaScript("window.importedModules="..hs.json.encode(selected)..";window.previewConfiguration(null)")
            end
            reply(success,result,body.action)
        end
        if body.action == "saveLauncher" then local success,result=launcher.save(body.config);reply(success,result,body.action) end
        if body.action == "saveGeneral" then local success, result = app.saveGeneral(body.config); reply(success, result, body.action) end
        if body.action == "save" then local success, result = app.save(body.config); reply(success, result, body.action) end
        if body.action == "savePopup" then local success, result = app.savePopup(body.config); reply(success, result, body.action) end
        if body.action == "saveBrowser" then local success, result = browser.save(body.config); reply(success, result, body.action) end
        if body.action == "openBrowserURL" then local success, result = browser.open(body.url,body.sourceBundle); reply(success, result, body.action) end
        if body.action == "testBrowserURL" then local selected, result = browser.resolve(body.url,body.sourceBundle); reply(selected~=nil,selected and i18n.t("将打开：")..(function() for _,item in ipairs(browser.browsers) do if item.id==selected then return item.name end end return selected end)() or result) end
        if body.action == "saveSystem" then local success, result = system.save(body.config); reply(success, result, body.action) end
        if body.action == "saveInput" then local success, result = input.save(body.config); reply(success, result, body.action) end
        if body.action == "saveClipboard" then local success, result = clipboard.save(body.config); reply(success, result, body.action) end
        if body.action == "pauseClipboard" then local success, result = clipboard.pause(); reply(success, result, body.action) end
        if body.action == "refreshClipboard" then reply(true, "") end
        if body.action == "previewClipboard" then
            local value, result = clipboard.preview(body.id)
            if value then app.settings:evaluateJavaScript("window.showImage("..hs.json.encode(value)..")") else reply(false,result) end
        end
        if body.action == "copyClipboard" then local success, result = clipboard.copy(body.id); reply(success, result, body.action) end
        if body.action == "clearClipboard" then local success, result = clipboard.clear(); reply(success, result, body.action) end
        if body.action == "chooseApp" or body.action == "chooseBrowserApp" or body.action == "chooseLauncherApp" then
            local prompt=body.action=="chooseLauncherApp" and i18n.t("选择要启动的应用") or body.action=="chooseBrowserApp" and i18n.t("选择链接来源应用") or i18n.t("选择要配置输入法的应用")
            local paths = hs.dialog.chooseFileOrFolder(prompt, "/Applications", true, false, false, {"app"}, true)
            local path = paths
            if type(paths)=="table" then path=paths[1] or paths["1"] end
            if type(path)=="string" and path ~= "" then
                local info = hs.application.infoForBundlePath(path)
                if info and info.CFBundleIdentifier then
                    local value = {bundleID=info.CFBundleIdentifier,name=info.CFBundleDisplayName or info.CFBundleName or info.CFBundleIdentifier}
                    local callback=body.action=="chooseLauncherApp" and "window.addLauncherRule(" or body.action=="chooseBrowserApp" and "window.addBrowserAppRule(" or "window.addInputRule("
                    app.settings:evaluateJavaScript(callback .. hs.json.encode(value) .. ")")
                else reply(false, i18n.t("无法识别所选应用")) end
            end
        end
    end)
    local file = assert(io.open(root .. "settings.html", "r"))
    local html = file:read("*a"); file:close()
    app.settings = hs.webview.new({x=180,y=160,w=980,h=720}, {}, app.controller)
        :windowStyle({"titled","closable","resizable"}):windowTitle(i18n.t("Nivlet 设置"))
        :transparent(false):allowTextEntry(true):html(html):show():bringToFront(true)
end
clipboard.startMenu(function(mode)
    local id=mode=="settings" and "clipEnabled" or "clipSearch"
    app.openSettings("clipSection",id)
end)
if popupConflicts(app.popupShortcut, app.config) then
    hs.alert.show(i18n.t("剪贴板菜单快捷键与窗口配置冲突，未启用菜单绑定"))
else
    local installed, errorMessage = installPopup(app.popupShortcut)
    if not installed then hs.alert.show(errorMessage) end
end
launcher.start(function(shortcut) return sameShortcut(shortcut,app.popupShortcut) or (shortcut and popupConflicts(shortcut,app.config)) end)
system.start(function() app.openSettings("systemSection") end)
app.menu = hs.menubar.new():setTitle(""):setTooltip(i18n.t("Nivlet 设置"))
if hs.image then app.menu:setIcon(hs.image.imageFromName("NSActionTemplate")) end
function app.updateMenu()
    app.menu:setTooltip(i18n.t("Nivlet 设置")):setMenu(nil)
    app.menu:setMenu({{title=i18n.t("设置…"),fn=app.openSettings},{title=i18n.t("退出 Nivlet"),fn=function() os.exit() end}})
end
app.updateMenu()
if not app.general.showMenu then app.menu:removeFromMenuBar() end
hs.dockIconClickCallback = function() app.openSettings("generalSection") end
print("Nivlet ready", hs.configdir, hs.settings.bundleID, "bindings", #app.bindings)
