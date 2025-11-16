
---@class DLux.FileRoute
local FileRoute = {}
FileRoute.__index = FileRoute

function FileRoute:__tostring()
    return self.routeName
end

function FileRoute:__call(...)
    return setmetatable({}, self):new()
end

function FileRoute:new()
    local o = setmetatable({}, FileRoute)
    o.transition = {
        stack = {},
        mode = nil,
        type = nil,
        duration = 0.35,
        t = 0
    }
    return o
end

function FileRoute:update(dt)
    if self.transition.type then
        self.transition.t = math.min(self.transition.t + dt, self.transition.duration)
        if self.transition.t >= self.transition.duration then self.transition = nil end
    end

    local top = self.transition.stack[#self.transition.stack]
    if top and top.update then top:update(dt) end
end

function FileRoute:draw()
    if not self.transition.type then
        local top = self.transition.stack[#self.transition.stack]
        if top and top.draw then top:draw(0, 0) end
        return
    end

    local mode = self.transition.mode
    local prev = self.transition.prev
    local next = self.transition.next
    local t = self.transition.t / self.transition.duration
    local w = love.graphics.getWidth()

    if mode == "slide" then
        love.graphics.push()
        love.graphics.translate(-w * t, 0)
        prev:draw(0, 0)
        love.graphics.pop()

        love.graphics.push()
        love.graphics.translate(w - w * t, 0)
        next:draw(0, 0)
        love.graphics.pop()

    elseif mode == "fade" then
        prev:draw(0, 0)
        love.graphics.setColor(1, 1, 1, t)
        next:draw(0, 0)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return FileRoute