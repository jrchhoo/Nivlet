package.path = "Toolkit/?.lua;" .. package.path
local stored, callbacks = {}, {}
local function menu() return setmetatable({}, {__index=function() return function(self) return self end end}) end
hs = {
    processInfo={bundleID="dev.local.DesktopToolkit",bundlePath="."}, configdir="/isolated/toolkit",
    settings={bundleID="dev.local.DesktopToolkit",get=function(k) return stored[k] end,set=function(k,v) stored[k]=v end},
    accessibilityState=function() return true end,
    menubar={new=menu}, alert={show=function() end},
    hotkey={assignable=function(_,k) return k ~= "9" end,systemAssigned=function() return false end,
        bind=function(_,k,fn) callbacks[k]=fn; return {delete=function() callbacks[k]=nil end} end},
}
package.loaded["modules.sys_info"]={start=function() end}
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
