local View = require("View_primitive")

local Profile = FileRoute:_extend()
Profile.routeName = "Profile"


function Profile:new()
    local Header = View:new({flexGrow=1, bgColor={0,0,1}})

    -- self.routeNode:addChild(Header)
    return self
end

function Profile:keypressed(key)
    if key == "a" then RouterManager:pop("slide") end
end



return Profile:new()