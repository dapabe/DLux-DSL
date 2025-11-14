local Yoga = require("luyoga")
local applyStyleProps = require("applyStyleProps")

---@class DLux.RectPrimitiveProps: DLux.UIPropsExtra
---@field bgColor? table<number, number, number, number>
---@field borderRadius? table<number, number> # X, Y

---@class DLux.RectPrimitive: DLux.ElementPrimitive, DLux.RectPrimitiveProps
---@field update? fun(self: self, dt: number)
local Rect = require("Element_primitive"):_extend()

function Rect:_drawDebugOutline()
    local l = self.UINode.layout
    love.graphics.setColor(0, 1, 0)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", l:getLeft(), l:getTop(), l:getWidth(), l:getWidth())
    -- love.graphics.setColor(1,1,1,1)
end

---@param parent DLux.RectPrimitive
function Rect:_inheritParentStyles(parent)
    self.bgColor = parent.bgColor
    self.borderRadius = parent.borderRadius
end

function Rect:__tostring()
    return "RectPrimitive"
end

function Rect:draw()
    if not self.UINode or not self.UINode.layout then return end

    local l = self.UINode.layout
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill",
        l:getLeft(), l:getTop(),
        l:getWidth(), l:getHeight(),
        self.borderRadius[1], self.borderRadius[2]
    )
    if self.debugOutline then self:_drawDebugOutline() end
end

---@param props DLux.RectPrimitiveProps
function Rect:new(props)
    ---@class DLux.RectPrimitive
    local obj = setmetatable({}, self)
    obj.UINode = Yoga.Node.new()
    applyStyleProps(obj.UINode.style, props or {})

    obj.debugOutline = props.debugOutline or false
    obj.bgColor = props.bgColor or {0, 0, 0, 0}
    obj.borderRadius = props.borderRadius or {0, 0}

    return obj
end

return Rect