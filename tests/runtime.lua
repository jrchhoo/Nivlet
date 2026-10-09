package.path = "Toolkit/?.lua;" .. package.path
local stored, callbacks = {}, {}
local function menu() return setmetatable({}, {__index=function() return function(self) return self end end}) end
hs = {
    processInfo={bundleID="dev.local.DesktopToolkit",bundlePath="."}, configdir="/isolated/toolkit",
    settings={bundleID="dev.local.DesktopToolkit",clear=function(k) stored[k]=nil end,get=function(k) return stored[k] end,set=function(k,v) stored[k]=v end},
    accessibilityState=function() return true end,
    menuIcon=function(value) assert(value==false) end,openConsoleOnDockClick=function(value) assert(value==false) end,nivletAppearance=function() end,menubar={new=menu}, alert={show=function() end},
    hotkey={assignable=function(_,k) return k ~= "9" end,systemAssigned=function() return false end,
        bind=function(_,k,fn) callbacks[k]=fn; return {delete=function() callbacks[k]=nil end} end},
}
package.loaded["modules.sys_info"]={start=function() end,menu=menu(),menuItems=function() return {} end}
dofile("Toolkit/init.lua")
assert(#desktopToolkit.bindings==0)
local old={enabled=true,shortcuts={left={key="1",mods={"ctrl","alt","cmd","shift"}}}}
assert(desktopToolkit.save(old)); assert(#desktopToolkit.bindings==1 and callbacks["1"])
local failure={enabled=true,shortcuts={left={key="2",mods={"ctrl"}},right={key="9",mods={"ctrl"}}}}
assert(not desktopToolkit.save(failure))
assert(callbacks["1"] and not callbacks["2"] and desktopToolkit.config.shortcuts.left.key=="1")
assert(stored["desktoptoolkit.preferences.v1"].shortcuts.left.key=="1")
local w={id=function() return 123 end,isStandard=function() return true end,isFullScreen=function() return false end,
    screen=function() return {frame=function() return {x=-1000,y=0,w=1000,h=800} end} end}
local actual={x=10,y=30,w=600,h=400}
w.frame=function() return actual end; w.setFrame=function(_,f) actual=f end
hs.window={focusedWindow=function() return w end}
callbacks["1"](); assert(actual.x==-1000 and actual.w==500)
assert(require("modules.windows").run("restore",w)); assert(actual.x==10 and actual.w==600)
assert(not require("modules.windows").run("restore",w))
assert(desktopToolkit.save({enabled=false,shortcuts={}})); assert(#desktopToolkit.bindings==0 and not callbacks["1"])
print("Runtime binding rollback, dispatch, restore and disable passed")

assert(desktopToolkit.general.showMenu and desktopToolkit.general.appearance=="system")
assert(not desktopToolkit.saveGeneral({showMenu=true,appearance="invalid"}))
assert(not stored["desktoptoolkit.general.v1"])
assert(desktopToolkit.saveGeneral({showMenu=false,appearance="dark"}))
assert(stored["desktoptoolkit.general.v1"].appearance=="dark")
assert(desktopToolkit.saveGeneral({showMenu=true,appearance="light"}))
assert(desktopToolkit.saveGeneral({showMenu=true,appearance="system"}))
local opened
local original=desktopToolkit.openSettings
desktopToolkit.openSettings=function(section) opened=section end
hs.dockIconClickCallback()
assert(opened=="generalSection")
desktopToolkit.openSettings=original
print("General settings validation, persistence and reopen dispatch passed")

assert(desktopToolkit.general.language=="system")
assert(not desktopToolkit.saveGeneral({showMenu=true,appearance="system",language="fr"}))
assert(desktopToolkit.saveGeneral({showMenu=true,appearance="system",language="en"}))
assert(require("modules.i18n").t("设置…")=="Settings…")
assert(stored["desktoptoolkit.general.v1"].language=="en")
assert(desktopToolkit.saveGeneral({showMenu=true,appearance="system",language="zh-Hans"}))
assert(require("modules.i18n").t("设置…")=="设置…")
print("Language validation, persistence and immediate switching passed")

local launcher=require("modules.launcher")
assert(launcher.save({enabled=true,rules={{bundleID="com.example.probe",name="Probe",shortcut={key="J",mods={"ctrl"}}}}}))
assert(not desktopToolkit.savePopup({key="j",mods={"ctrl"}}))
assert(not desktopToolkit.save({enabled=true,shortcuts={left={key="J",mods={"ctrl"}}}}))
assert(desktopToolkit.savePopup({key="K",mods={"ctrl"}}))
assert(not launcher.save({enabled=true,rules={{bundleID="com.example.probe",shortcut={key="K",mods={"ctrl"}}}}}))
assert(desktopToolkit.save({enabled=false,shortcuts={right={key="L",mods={"ctrl"}}}}))
assert(not launcher.save({enabled=true,rules={{bundleID="com.example.probe",shortcut={key="L",mods={"ctrl"}}}}}))
assert(callbacks["J"] and launcher.config.rules[1].shortcut.key=="J")
print("Bidirectional launcher, window and clipboard shortcut conflicts passed")

-- Import must release all three shortcut owners before moving a binding.
hs.application={pathForBundleID=function() return "/Applications/Test.app" end}
local manager=desktopToolkit.configuration
local function document(modules) return {format="Nivlet",version=1,modules=modules} end
assert(manager.apply(document({windows={enabled=true,shortcuts={left={key="J",mods={"ctrl"}}}},launcher={enabled=false,rules={}},popupShortcut=false})))
assert(callbacks["J"] and not callbacks["K"] and #launcher.bindings==0)
local before=stored["desktoptoolkit.preferences.v1"]
local imported,message=manager.apply(document({windows={enabled=true,shortcuts={left={key="9",mods={"ctrl"}}}},popupShortcut=false,launcher={enabled=false,rules={}}}))
assert(not imported and message:find("已恢复原配置",1,true))
assert(callbacks["J"] and not callbacks["9"] and desktopToolkit.config.shortcuts.left.key=="J")
assert(stored["desktoptoolkit.preferences.v1"]==before)
assert(manager.apply(document({windows={enabled=false,shortcuts={}},popupShortcut={key="J",mods={"ctrl"}}})))
assert(desktopToolkit.popupBinding and callbacks["J"] and #desktopToolkit.bindings==0)
print("Actual runtime import swaps shortcut owners and restores bindings plus saved configuration after registration failure")
