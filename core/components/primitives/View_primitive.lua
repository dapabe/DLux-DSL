local Yoga = require("luyoga")
local applyStyleProps = require("applyStyleProps")
local Rect = require("Rect_primitive")

---@class DLux.ViewPrimitiveProps: DLux.RectPrimitiveProps
---@field bgColor? table<number, number, number, number>

---@class DLux.ViewPrimitive: DLux.RectPrimitive, DLux.ViewPrimitiveProps
---@field children DLux.RectPrimitive[]
---@field update? fun(self: self) # Should be overriden when extended
local View = Rect:_extend()

--------------------------------------------------------------------
-- CHILDREN MANAGEMENT
--------------------------------------------------------------------

---@param child DLux.RectPrimitive
---@param inherit? boolean
function View:addChild(child, inherit)
    assert(child ~= self, "ERROR: trying to add view as child of itself")
    assert(child.UINode ~= self.UINode, "ERROR: trying to add UINode as child of itself")

    if inherit or false then child:_inheritParentStyles(self) end

    table.insert(self.children, child)
    self.UINode:insertChild(child.UINode, #self.children)
end

---@param child DLux.RectPrimitive
function View:removeChild(child)
    for i,v in ipairs(self.children) do
        if v == child then
            self.UINode:removeChild(child.UINode)
            table.remove(self.children, i)
            return
        end
    end
end

function View:clearChildren()
    for _,child in ipairs(self.children) do
        self.UINode:removeChild(child.UINode)
    end
    self.children = {}
end

--------------------------------------------------------------------
-- Love2D API
--------------------------------------------------------------------

---@param dt number
function View:update(dt)
    for _,child in ipairs(self.children) do
        if child.update then
            child:update(dt)
        end
    end
end

function View:draw()
    Rect.draw(self)

    -- Draw children
    local l = self.UINode.layout

    love.graphics.push()
        
        love.graphics.translate(l:getLeft(), l:getTop())
        
        for _, child in ipairs(self.children) do
            child:draw()
        end

    love.graphics.pop()
end

---@param props DLux.ViewPrimitiveProps
function View:new(props)
    ---@class DLux.ViewPrimitive
    local base = Rect.new(self, props or {})
    base.children = {}
    return base
end

return View