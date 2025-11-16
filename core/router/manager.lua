local View_primitive = require "View_primitive"

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

---@alias AnimMode "slide" | "fade"

---@class TransitionAnimation
---@field mode AnimMode
---@field reverse boolean

---@class RouterManager
---@field _routes DLux.FileRoute[]
---@field _tabs DLux.FileRoute[]
---@field _transition 
---@field rootNode DLux.ViewPrimitive
local Manager = {}
Manager.__index = Manager

-------------------------------------------------------------------
-- INTERNAL
-------------------------------------------------------------------

---@param route DLux.FileRoute
---@return DLux.FileRoute
function Manager:_mountRoute(route)
	route = route:new()
	assert(route and route.routeNode, "[RouteManager] ERROR(_mountRoute) route requires luyoga node")
	self.rootNode:addChild(route.routeNode)
	self.rootNode.UINode:removeAllChildren()
	self.rootNode.UINode:insertChild(route.routeNode.UINode, 1)
	self.rootNode.UINode:calculateLayout(self.rootNode.UINode.layout:getWidth(), self.rootNode.UINode.layout:getHeight(), Yoga.Enums.Direction.LTR)
	return route
end

---@param event RouteEvent
function Manager:emit(event, ...)
    local route = self._routes[#self._routes]
    if route and route[event] then route[event](route, ...) end
end

-------------------------------------------------------------------
-- ROUTING API
-------------------------------------------------------------------

---@param next DLux.FileRoute
---@param animation AnimMode
---@param ... any[]
function Manager:enter(next, animation, ...)
	assert(next, "[RouteManager] ERROR(enter): route cannot be nil")
    local previous = self._routes[#self._routes]
	
    self:emit("leave", next, ...)
    self._routes[#self._routes] = next

	self:_mountRoute(next)

    self:emit("enter", previous, ...)
end

---@param next DLux.FileRoute
---@param ... any[]
function Manager:push(next, ...)
	assert(next, "[RouteManager] ERROR(push): route cannot be nil")
    local previous = self._routes[#self._routes]

    self:emit("pause", next, ...)
    self._routes[#self._routes+1] = next

   	next = self:_mountRoute(next)

	self:pushAnimation(next, previous)
    self:emit("enter", previous, ...)
end

--- Deletes the current route from the stack and returns to the previous one
function Manager:pop(...)
    local previous = self._routes[#self._routes]
    local next = self._routes[#self._routes - 1]
	assert(next, "[RouteManager] ERROR(pop): no more routes in stack")
    
	self:emit("leave", next, ...)
    self._routes[#self._routes] =  nil

	self:_mountRoute(next)

    self:emit("resume", previous, ...)
end

-------------------------------------------------------------------
-- TRANSITION ANIMATION
-------------------------------------------------------------------

---@param next DLux.FileRoute
---@param prev DLux.FileRoute | nil
---@param mode? "slide" | "fade" # Defaults to slide
function Manager:pushAnimation(next, prev, mode)
	if prev then
		self.transition = {
			mode = mode or "slide",
			prev = prev,
			next = next,
			reverse = true
		}
		self.t = 0
	end
end

function Manager:popAnimation()
end

-------------------------------------------------------------------
-- TABS
-------------------------------------------------------------------

function Manager:setTabs(tabs, index)
	self._tabs = tabs
end

-------------------------------------------------------------------
-- Love2D CALLBACK HOOKING
-------------------------------------------------------------------

---@param options? {include: string[], exclude: string[]}
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
-- PUBLIC
-------------------------------------------------------------------

---@param dt number
function Manager:update(dt)
	self.rootNode:update(dt)
	-- self._routes[#self._routes]:update(dt)
end

function Manager:draw()
	self.rootNode:draw()
	-- self._routes[#self._routes]:draw()
end

local Router = {}

function Manager:initYoga(width, height)
	self.rootNode = View_primitive:new({w= width, h= height})
	self.rootNode.UINode.style:setFlexGrow(1)
	self.rootNode.UINode.style:setFlexDirection(Yoga.Enums.FlexDirection.Column)
	self.rootNode.UINode:calculateLayout(width, height, Yoga.Enums.Direction.LTR)
end

function Router.new()
    local o = setmetatable({}, Manager)
	o._routes = {}
	o._tabs = {}
	return o
end

return Router