require("core.utils.printTable")
local localLibs = "./libs/share/lua/5.4/?.lua;./libs/share/lua/5.4/?/init.lua;"
local localLibs_C = "./libs/lib/lua/5.4/?.so;"
local coreLib = "./core/components/primitives/?.lua;"
local utils = "./core/utils/?.lua;./core/hmr/?.lua;"

package.path = localLibs..coreLib..utils..package.path
package.cpath =  localLibs_C..package.cpath

local Yoga = require ("luyoga")

local Watcher = require("watcher")
local Refresh = require("refresh")

local w

---@type DLux.ViewPrimitive
local root
local View = require("View_primitive")
local Rect = require("Rect_primitive")

function love.load()
    w = Watcher.new("", 0.5)

    love.window.setMode(400, 600)
    root = root or View:new({ w=400, h=600, bgColor={0.2,0.2,0.2} })

    local header = View:new({h=50, flexDir="row", flexJustify = "between", bgColor={1,1,1}}) -- White
    local box1 = Rect:new({ w=50, h=50, bgColor={0,0,1}})
    local box2 = Rect:new({ w=50, h=50, bgColor={0,1,1}})
    header:addChild(box1)
    header:addChild(box2)
    
    local body   = View:new({flexGrow=.2, bgColor={.8,0.1,0.3}, debugOutline = true}) -- Red box

    root:addChild(header)
    root:addChild(body)

    root.UINode.style:setFlexDirection(Yoga.Enums.FlexDirection.Column)
    root.UINode:calculateLayout(400, 500, Yoga.Enums.Direction.LTR)
end

function love.update(dt)
    local changed = w:update(dt)
    if changed then
        print("[HMR] archivo modificado:", changed)

        -- convierte "src/components/Button.lua" -> "src.components.Button"
        local modulePath = changed
            :gsub("%.lua", "")
            :gsub("/", ".")

        Refresh.reload(modulePath)
    end
end

function love.draw()
    if root then root:draw() end
end