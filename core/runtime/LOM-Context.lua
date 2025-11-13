
-- Lua Object Model Context
---@class LOMContext
local LOMContext = {}

---@type luyoga.Node | nil
LOMContext.activeNode = nil
---@type luyoga.Node | nil
LOMContext.hoveredNode = nil

LOMContext.mouseX = 0
LOMContext.mouseY = 0

---@type luyoga.Node | nil
LOMContext.scrollActive = nil
LOMContext.draggingBar = false
LOMContext.dragOffsetY = 0

---@param x number
---@param y number
---@param rx number
---@param ry number
---@param rw number
---@param rh number
function LOMContext.isInsideRect(x, y, rx, ry, rw, rh)
    return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

---@param node luyoga.Node
function LOMContext.isMouseInScrollable(node)
    return LOMContext.isInsideRect(LOMContext.mouseX, LOMContext.mouseY, 0,0, node.layout:getWidth(), node.layout:getHeight())
end

function LOMContext.update()
    LOMContext.mouseX, LOMContext.mouseY = love.mouse.getPosition()

    if LOMContext.activeNode and not LOMContext.draggingBar then
        
    end
end

return LOMContext