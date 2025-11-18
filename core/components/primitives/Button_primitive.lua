---@class DLux.ButtonPrimitiveProps: DLux.ViewPrimitiveProps
---@field eventFn? function

---@class DLux.ButtonPrimitive: DLux.ButtonPrimitiveProps
local Button = require("View_primitive"):_extend()

-- Button.color = {.5, .5, .8}
-- Button.colorHover = {.7, .7, .9}


Button.eventFn = function() end

function Button:isHovered()
    local mx, my = love.mouse.getPosition()
    return mx > self.x and mx < self.x + self.w and my > self.y and my < self.y + self.h
end

function Button:onPress(mx, my, btn)
    Button.super.onPress(self, mx, my, btn)
    if btn == 1 then
        self:eventFn()
    end
end

-- function Button:update()
--     self.hovered = self:isHovered()
-- end

function Button:draw()
    Button.super.draw(self)
end

---@param callback function
---@param props? DLux.ButtonPrimitiveProps
function Button:new(callback, props)
    props = props or {}
    ---@class DLux.ButtonPrimitive
    local o = Button.super.new(self, props)
    o._ElementName = "ButtonPrimitive"

    if callback then o.eventFn = callback end

    for key, value in pairs(props) do
        if key == "children" then goto continue end
        self[key] = value
        ::continue::
    end

    o.cursorHover = props.cursorHover or "hand"

    return o
end

return Button
