---@class DLux.FileRoute
---@field super self
local FileRoute = {}
FileRoute.__index = FileRoute

function FileRoute:new()
    local o = setmetatable({}, self)
    o.routeNode = GUI.View:new({ flexGrow = 1 })
    return o
end

function FileRoute:extend()
    local cls = setmetatable({}, self)
    cls.__index = cls
    cls.super = self
    return cls
end

function FileRoute:keypressed(key)
    if DEBUG and key == "r" then
        -- print("Reload " .. self.routeName)
        local currentChildren = self.routeNode.children
        -- self.routeNode:clearChildren()
        -- for _, child in ipairs(currentChildren) do
        --     self.routeNode:addChild(child)
        -- end
        -- self.routeNode.UINode:calculateLayout(nil, nil, Yoga.Enums.Direction.LTR)
        RouterManager:refresh()
    end
end

function FileRoute:update(dt)
    self.routeNode:update(dt)
end

function FileRoute:draw()
    self.routeNode:draw()
end

return FileRoute
