---@class DLux.TextPrimitiveProps: DLux.RectPrimitive
---@field textColor? table<number, number, number, number>
---@field textAlign? string
---@field rotation? number # 0 - 360 deg
---@field font? love.Font | nil

---@class DLux.TextPrimitive: DLux.TextPrimitiveProps
---@field _text string # [INTERNAL]
local Text = require("Rect_primitive"):_extend()

local DEFAULT_COLOR = { 0, 0, 0, 1 }

--------------------------------------------------------------------
-- INTERNAL
--------------------------------------------------------------------

function Text:_recalculateSize(maxWidth)
    if not maxWidth or maxWidth <= 0 then return end

    local font = self.font
    local _, lines = font:getWrap(self._text, maxWidth)

    local textHeight = #lines * font:getHeight()

    -- ACTUALIZAR SOLO height, el width lo limita el padre vía maxWidth
    self.UINode.style:setMaxWidth(maxWidth)
    self.UINode.style:setHeight(textHeight)

    self._naturalHeight = textHeight
end

---@param parent luyoga.Node
function Text:_onChildAdded(parent)
    local pw = parent.layout:getWidth()
    self:_recalculateSize(pw)
    self._lastParentWidth = pw
end

--------------------------------------------------------------------
-- PUBLIC
--------------------------------------------------------------------

---@param value string | number | boolean
function Text:setText(value)
    self._text = tostring(value)
    self._needsRecalc = true
end

function Text:update(dt)
    Text.super.update(self, dt)

    local parent = self.UINode:getParent()
    if not parent then return end

    local pw = parent.layout:getWidth()
    -- print(parent:getChildCount())
    -- 1. No recalcular si el padre aún NO tiene ancho válido
    if pw == nil or pw == 0 then
        return
    end

    -- 2. Recalcular solo si el ancho del padre cambió
    if pw ~= self._lastParentWidth then
        self:_recalculateSize(pw)
        self._lastParentWidth = pw
    end
end

function Text:draw()
    Text.super.draw(self)
    local l = self.UINode.layout
    local x = l:getLeft()
    local y = l:getTop()
    love.graphics.rotate(self.rotation)
    love.graphics.setColor(self.textColor)
    love.graphics.printf(self._text, x, y, self._lastParentWidth)
end

---@param value string | number | boolean
---@param props? DLux.TextPrimitiveProps
function Text:new(value, props)
    props = props or {}
    ---@class DLux.TextPrimitive
    local o = Text.super.new(self, props)

    o._ElementName = "TextPrimitive"

    o._text = tostring(value)
    o.textColor = props.textColor or DEFAULT_COLOR
    o.textAlign = props.textAlign or "left"
    o.rotation = props.rotation or 0
    o.font = props.font or love.graphics.getFont()


    return o
end

return Text
