local Route = FileRoute:extend()
Route.routeName = "Root"

function Route:new()
    local o = Route.super.new(self)
    o.routeNode.bgColor = { 1, 1, 1 }
    local NavBar = GUI.View:new({ h = 50, flexDir = "row" })


    local ProfileBtn = GUI.Button:new(function()
        RouterManager:push(RouteList.Profile, "slide")
    end, { w = 50, h = 50, bgColor = { 0, 1, 1 }, borderRadius = 8, cursorHover = "hand" })

    local BOX = GUI.View:new({ flexGrow = .6, bgColor = { 0, .4, .4 }, debugOutline = true })
    local TXT = GUI.Text:new("TestasdaaaaaaaaaaaaaaaaTesta ", { debugOutline = true, selfAlign = "end" })
    -- local INNERBOX = GUI.Rect:new({ flexGrow = 1, bgColor = { 1, 1, 1 } })
    BOX:addChild(TXT)

    NavBar:addChild(ProfileBtn)
    NavBar:addChild(BOX)
    -- NavBar:addChild(INNERBOX)

    local body = GUI.View:new({ flexGrow = 1, bgColor = { .8, 0.1, 0.3 }, debugOutline = true, cursorHover = "hand" })
    o.routeNode:addChild(NavBar)
    o.routeNode:addChild(body)
    return o
end

function Route:enter(next)
end

function Route:update(dt)
    Route.super.update(self, dt)
end

function Route:keypressed(key, repeated)
    Route.super.keypressed(self, key, repeated)
    if key == "s" then RouterManager:pop("fade") end
end

function Route:draw()
    Route.super.draw(self)
end

return Route
