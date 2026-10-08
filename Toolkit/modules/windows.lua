local M = {}
local originals = {}
M.actions = {"left", "right", "maximize", "restore"}
function M.frame(action, bounds)
    if action == "maximize" then return {x=bounds.x,y=bounds.y,w=bounds.w,h=bounds.h} end
    if action == "left" then return {x=bounds.x,y=bounds.y,w=bounds.w/2,h=bounds.h} end
    if action == "right" then return {x=bounds.x+bounds.w/2,y=bounds.y,w=bounds.w/2,h=bounds.h} end
end
function M.run(action, window)
    if not hs.accessibilityState() then return false, "请先开启辅助功能权限" end
    local w = window or hs.window.focusedWindow()
    if not w or not w:isStandard() or w:isFullScreen() then return false, "请选择可调整的普通窗口" end
    local id = w:id()
    if action == "restore" then
        if not originals[id] then return false, "此窗口没有可恢复的位置" end
        w:setFrame(originals[id], 0); originals[id] = nil
    else
        local target = M.frame(action, w:screen():frame())
        if not target then return false, "未知窗口操作" end
        if not originals[id] then originals[id] = w:frame() end
        w:setFrame(target, 0)
    end
    return true
end
return M
