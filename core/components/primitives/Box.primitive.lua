
---@class BoxPrimitive: ElementPrimitive, UILayoutPrimitive
local Box = require("tlux.components.primitives.Item.primitive")

Box.x, Box.y, Box.w, Box.h = 0, 0, 0, 0
Box.color = {0, 0, 0, 0}
Box.padding = 0
Box.size = {flexGrow = 1}

function Box:__tostring()
    return "BoxPrimitive"
end


return Box