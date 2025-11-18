local loadTimeStart = love.timer.getTime()
require("globals")

local Refresh = require("core.hmr.Refresh")
local watcher = require("core.hmr.Watcher").new("", 0.5)




function love.load()
    love.window.setMode(400, 600)

    RouterManager:initYoga(400, 600)
    RouterManager:hook()

    RouterManager:enter(RouteList.Root)

    if DEBUG then
        local loadTimeEnd = love.timer.getTime()
        local loadTime = loadTimeEnd - loadTimeStart
        print(("Load app in %.3f seconds."):format(loadTime))
    end
end

function love.update(dt)
    if DEBUG then
        local changed = watcher:update(dt)
        if changed then
            print("[HMR] archivo modificado:", changed)

            -- convierte "src/components/Button.lua" -> "src.components.Button"
            local modulePath = changed
                :gsub("%.lua", "")
                :gsub("/", ".")

            Refresh.reload(modulePath)
        end
    end
    RouterManager:update(dt)
end

function love.draw()
    local drawTimeStart = love.timer.getTime()
    RouterManager:draw()
    local drawTimeEnd = love.timer.getTime()
    local drawTime = drawTimeEnd - drawTimeStart
end

function love.threaderror(thread, errorMessage)
    print("Thread error!\n" .. errorMessage, thread)
    love.window.showMessageBox("Error", errorMessage, "error")
end
