
---@class ScrollViewPrimitive: ViewPrimitive
local ScrollView = require("View.primitive")

ScrollView.scrollY = 0
ScrollView.scrollSpeed = 60
ScrollView.isDragging = false
ScrollView.dragOffset = 0
ScrollView.accumulatedHeight = 0

function ScrollView:isMouseInside(mx, my)
        return mx >= self.x and mx <= self.x + self.w
       and my >= self.y and my <= self.y + self.h
end

function ScrollView:getMaxScroll()
    return math.max(0, self.accumulatedHeight - self.h)
end

function ScrollView:getScrollbar()
    local maxScroll = self:getMaxScroll()
    if maxScroll <= 0 then return nil end

    local barW = 8
    local barX = self.x + self.w - barW

    local barH = self.h * (self.h / self.accumulatedHeight)
    barH = math.max(20, barH)

    local travel = self.h - barH
    local barY = self.y + (self.scrollY / maxScroll) * travel
    return {
        x = barX,
        y = barY,
        w = barW,
        h = barH
    }
end

function ScrollView:isOverScrollbar(mx, my)
    local sb = self:getScrollbar()
    if not sb then return false end

    return mx >= sb.x and mx <= sb.x + sb.w and my >= sb.y and my <= sb.y + sb.h
end

function ScrollView:mousePressed(mx, my, btn)
    if btn ~= 1 then return end

    if not self:isMouseInside(mx, my) then
        self.hasFocus = false
        return
    end
    self.hasFocus = true

    if self:isOverScrollbar(mx, my) then
        self.isDragging = true
        local sb = self:getScrollbar()
        if not sb then return end
        self.dragOffset = my - sb.y
    end
end


function ScrollView:mouseReleased(mx, my, btn)
    if btn ~= 1 then return end
    self.isDragging = false
end

function ScrollView:_update(dt, mx, my, wheelY)
    local maxScroll = self:getMaxScroll()
    if maxScroll == 0 then
        self.scrollY = 0
        return
    end

    -- wheel scroll
    if self.hasFocus and not self.isDragging then
        self.scrollY = self.scrollY - wheelY * self.scrollSpeed
    end

    -- dragging scrollbar
    if self.isDragging then
        local sb = self:getScrollbar()
        if sb then
            local travelDistance = self.h - sb.h
            
            local localY = (my - self.dragOffset) - self.y
            local ratio = localY - travelDistance
            ratio = math.max(0, math.min(1, ratio))

            self.scrollY = ratio * maxScroll
        end
    end

    self.scrollY = math.max(0, math.min(self.scrollY, maxScroll))
end

function ScrollView:_draw(drawCallback)
    -- Clip viewport area
    love.graphics.setScissor(self.x, self.y , self.w, self.h)

    love.graphics.push()
    love.graphics.translate(self.x, self.y - self.scrollY)

    if drawCallback then drawCallback() end

    love.graphics.pop()
    love.graphics.setScissor()

    local sb = self:getScrollbar()
    if sb then
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", sb.x, sb.y, sb.w, sb.h, 4, 4)
        love.graphics.setColor(1, 1, 1)
    end
end

return ScrollView