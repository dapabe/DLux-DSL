local View = require "View_primitive"

---@class DLux.FileRoute
local FileRoute = {}
FileRoute.__index = FileRoute

function FileRoute:new()
    local o = setmetatable({}, FileRoute)
    o.routeNode = View:new({flexGrow = 1})
    printTable(o.routeNode)
    return o
end

function FileRoute:_extend()
    local cls = {}
    for k, v in pairs(self) do
        if k:find("__") == 1 then cls[k] = v end
    end
    cls.__index = cls
    cls.super = self

    return setmetatable(cls, self):new()
end

function FileRoute:__call(...)
    return setmetatable({}, self):new()
end

function FileRoute:update(dt)
    self.routeNode:update(dt)
end

function FileRoute:draw()
    self.routeNode:draw()
end

return FileRoute