package.path = "Toolkit/?.lua;" .. package.path
local p = require("modules.preferences")
assert(p.defaults().enabled == false)
assert(not p.validate({enabled=true,shortcuts={left={key="K",mods={"shift"}}}}))
assert(not p.validate({enabled=true,shortcuts={left={key="K",mods={"cmd","ctrl"}},right={key="k",mods={"ctrl","cmd"}}}}))
assert(not p.validate({enabled=true,shortcuts={left={key="F12",mods={"ctrl"}}}}))
local valid = assert(p.validate({enabled=false,shortcuts={left={key="",mods={}},right={key="k",mods={"ctrl","cmd"}}}}))
assert(valid.shortcuts.left == nil and valid.shortcuts.right.key == "K")
local w = require("modules.windows")
local right = w.frame("right", {x=-1920,y=40,w=1920,h=1040})
assert(right.x == -960 and right.y == 40 and right.w == 960 and right.h == 1040)
print("Preferences validation and negative-coordinate window geometry passed")

for input,expected in pairs({left="left",RIGHT="right",ArrowUp="up",["↓"]="down"}) do
    local cfg=assert(p.validate({enabled=true,shortcuts={left={key=input,mods={"ctrl","alt"}}}}))
    assert(cfg.shortcuts.left.key==expected)
end
assert(not p.validate({enabled=true,shortcuts={left={key="ArrowLeft",mods={"ctrl"}},right={key="←",mods={"ctrl"}}}}))
print("Arrow keys normalize to Runtime key names and duplicate aliases are rejected")
