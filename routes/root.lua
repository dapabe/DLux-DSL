local View = require("View_primitive")
local Rect = require("Rect_primitive")

---@class DLux.FileRoute
local Route = FileRoute:_extend()
Route.routeName = "Root"

function Route:new()
    local header = View:new({h=50, flexDir="row", flexJustify = "between", bgColor={1,1,1}})
    local box1 = Rect:new({ w=50, h=50, bgColor={0,0,1}})
    local box2 = Rect:new({ w=50, h=50, bgColor={0,1,1}})
    print(type(box1))
    -- header:addChild(box1)
    -- header:addChild(box2)
    
    local body = View:new({flexGrow=1, bgColor={.8,0.1,0.3}, debugOutline = true, cursorHover = "hand"})

    -- self.routeNode:addChild(header)
    -- self.routeNode:addChild(body)
    return self
end

function Route:enter(next)

end

function Route:update()

end

function Route:keypressed(key)
    if key == "a" then RouterManager:push(RouteList.Profile,"slide") end
    if key == "s" then RouterManager:pop("fade") end
end

function Route:draw()
    FileRoute.draw(self)
end

return Route:new()