local Yoga = require("luyoga")

---@alias RouteEvent "enter" | "leave" | "pause" | "resume" |"push" | string

local loveCallbacks = {
	'directorydropped',
	'draw',
	'filedropped',
	'focus',
	'gamepadaxis',
	'gamepadpressed',
	'gamepadreleased',
	'joystickaxis',
	'joystickhat',
	'joystickpressed',
	'joystickreleased',
	'joystickremoved',
	'keypressed',
	'keyreleased',
	'load',
	'lowmemory',
	'mousefocus',
	'mousemoved',
	'mousepressed',
	'mousereleased',
	'quit',
	'resize',
	'run',
	'textedited',
	'textinput',
	'threaderror',
	'touchmoved',
	'touchpressed',
	'touchreleased',
	'update',
	'visible',
	'wheelmoved',
	'joystickadded',
}

-- returns a list of all the items in t1 that aren't in t2
local function exclude(t1, t2)
	local set = {}
	for _, item in ipairs(t1) do set[item] = true end
	for _, item in ipairs(t2) do set[item] = nil end
	local t = {}
	for item, _ in pairs(set) do
		table.insert(t, item)
	end
	return t
end

---@class DLux.FileRoute
---@field routeNode luyoga.Node
---@field emit fun(self: self, event: RouteEvent, ...)
---@field enter fun(self: self, next: DLux.FileRoute, ...)
---@field push fun(self: self, next: DLux.FileRoute, ...)

---@class RouterManager: DLux.FileRoute
local Manager = {}
Manager.__index = Manager

---@protected
---@type DLux.FileRoute[]
Manager.__routes = {}
--- Root Yoga node for the whole app
Manager.rootNode = Yoga.Node.new()

-- Position root at (0,0)
Manager.rootNode.style:setFlexGrow(1)
Manager.rootNode.style:setFlexDirection(Yoga.Enums.FlexDirection.Column)

-------------------------------------------------------------------
-- INTERNAL
-------------------------------------------------------------------

---@param route DLux.FileRoute
function Manager:_mountRoute(route)
	assert(route and route.routeNode, "[RouteManager] Route requires luyoga node")
	self.rootNode:removeAllChildren()
	self.rootNode:insertChild(route.routeNode, 1)
	self.rootNode:calculateLayout(0, 0, Yoga.Enums.Direction.LTR)
end

function Manager:emit(event, ...)
    local route = self.__routes[#self.__routes]
    if route and route[event] then route[event](route, ...) end
end

-------------------------------------------------------------------
-- ROUTING API
-------------------------------------------------------------------

---@param next DLux.FileRoute
---@param ... any[]
function Manager:enter(next, ...)
	assert(next, "[RouteManager] ERROR(enter): route cannot be nil")
    local previous = self.__routes[#self.__routes]

    self:emit("leave", next, ...)
    self.__routes[#self.__routes] = next

	self:_mountRoute(next)

    self:emit("enter", previous, ...)
end

---@param next DLux.FileRoute
---@param ... any[]
function Manager:push(next, ...)
	assert(next, "[RouteManager] ERROR(push): route cannot be nil")
    local previous = self.__routes[#self.__routes]

    self:emit("pause", next, ...)
    self.__routes[#self.__routes+1] = next

   	self:_mountRoute(next)

    self:emit("enter", previous, ...)
end

--- Deletes the current route from the stack and returns to the previous one
function Manager:pop(...)
    local previous = self.__routes[#self.__routes]
    local next = self.__routes[#self.__routes - 1]
	assert(next, "[RouteManager] ERROR(pop): no more routes in stack")
    
	self:emit("leave", next, ...)
    self.__routes[#self.__routes] =  nil

	self:_mountRoute(next)

    self:emit("resume", previous, ...)
end

-------------------------------------------------------------------
-- Love2D CALLBACK HOOKING
-------------------------------------------------------------------

---@param options {include: string[], exclude: string[]}
function Manager:hook(options)
    options = options or {}
    local callbacks = options.include or loveCallbacks
    if options.exclude then callbacks = exclude(callbacks, options.exclude) end
    for _, callbackName in ipairs(callbacks) do
        local oldCallback = love[callbackName]
        love[callbackName] = function (...)
            if oldCallback then oldCallback(...) end
            self:emit(callbackName, ...)
        end
    end
end

-------------------------------------------------------------------
-- PUBLIC: CREATE ROUTER
-------------------------------------------------------------------
function Manager.new()
    return setmetatable({{}}, Manager)
end

return Manager