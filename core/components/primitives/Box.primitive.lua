local Yoga = require("luyoga")

---@class BoxPrimitive: ElementPrimitive, UILayoutPrimitive
local Box = require("tlux.components.primitives.Item.primitive")

Box.UINode = Yoga.Node.new()

Box.x, Box.y, Box.w, Box.h = 0, 0, 0, 0
Box.color = {0, 0, 0, 0}
Box.padding = 0
Box.size = {flexGrow = 1}
Box.hasFocus = false

function Box:__tostring()
    return "BoxPrimitive"
end

function Box:_updateLayout()
    
end

return Box