
---@class TextPrimitive: ViewPrimitive
---@field text string
local Text = require("tlux.components.primitives.Item.primitive"):extend()

Text.text = ""
Text.textAlign = "center"
Text.textColor = {1, 1, 1, 1}
Text.selectedColor = {0, 0, 0, 0}
Text.selectable = true
Text.fade = true

Text.colorHover = {0,0,0,0}

---@param self self
---@param menu MenuPrimitive
---@param dt number
function Text.setColor(self, menu, dt)
    local internal = menu.internal
    if not internal.fadeTime then internal.fadeTime = 0 end
    
    internal.fadeTime = (internal.fadeTime + dt) % (math.pi * 2)
    self.color[1] = math.max(0.25, (math.abs(math.cos(menu.internal.fadeTime))))
    self.color[2] = 0.75
    self.color[3] = math.max(0.25, (math.abs(math.cos(menu.internal.fadeTime))))
    self.color[4] = 1
end

---@param text string
---@param props table
function Text:new(text, props)
    if props then
        for k, v in pairs(props) do
            self[k] = v
        end
    end
    self.text = text
    self.color = self.color
end

function Text:_update(menu, dt)
    if menu:currentItem() == self then
        self.color = self.selectedColor
        if self.fade then self:setColor(menu, dt) end
    else
        self.color = self.textColor
    end
end

function Text:_draw(menu, x, y, w, h)
    if self.text then
        menu.funcs.drawText(menu, self.text, self.color, x, y, w, h, self.textAlign)
    end
end

function Text.__tostring()
    return "TextPrimitive"
end

return Text