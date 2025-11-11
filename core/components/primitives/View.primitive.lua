
---@class ViewPrimitive: BoxPrimitive, UINode
---@field _update? fun(self: self) # Should be overriden when extended
local View = require("Box.primitive"):extend()

View.children = {}
View.flexDirection = "row"
View.flexJustify = "start"
View.flexAlign = "start"

function View:_draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",
        self._computed.x, self._computed.y,
        self._computed.width, self._computed.height
    )
end

return View