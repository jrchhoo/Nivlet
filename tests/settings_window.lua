local file=assert(io.open("Toolkit/init.lua"));local source=file:read("*a");file:close()
local helper=assert(source:match("(local function showSettingsWindow%(view%).-)\nfunction app.openSettings"))
local calls={}
local view={level=function(self,value) assert(value==0);table.insert(calls,"normal");return self end,show=function(self) table.insert(calls,"show");return self end,hswindow=function() return {application=function() return {activate=function() table.insert(calls,"activate") end} end,focus=function() table.insert(calls,"focus") end} end}
local show=assert(load(helper.."\nreturn showSettingsWindow",nil,"t",{hs={drawing={windowLevels={normal=0}}},table=table}))()
show(view);assert(table.concat(calls,",")=="normal,show,activate,focus")
view.hswindow=function() return nil end;show(view)
assert(not source:find("bringToFront",1,true))
local _,count=source:gsub("showSettingsWindow%(app.settings%)","");assert(count==2)
print("Settings creation and reopening use normal window level; focus and missing window cases passed")
