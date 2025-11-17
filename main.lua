require("globals")
local loadTimeStart = love.timer.getTime()

local Watcher = require("watcher")
local Refresh = require("refresh")

local w

function love.load()
    if DEBUG then w = w or Watcher.new("", 0.5) end
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

local time = 0
function love.update(dt)
    if DEBUG and w then
        local changed = w:update(dt)
        if changed then
            print("[HMR] File modified:", "<rootDir>" .. changed)

            -- convierte "src/components/Button.lua" -> "src.components.Button"
            local modulePath = changed
                :gsub("%.lua", "")
                :gsub("/", ".")
            Refresh.reload(modulePath)
            -- root:calculateLayout(400, 600, Yoga.Enums.Direction.LTR)
        end
    end
    time = time + dt
    if time >= 1 / 60 then
        time = 0
    end
    -- RouterManager:update(dt)
end

function love.draw()
    local drawTimeStart = love.timer.getTime()
    -- RouterManager:draw()
    local drawTimeEnd = love.timer.getTime()
    local drawTime = drawTimeEnd - drawTimeStart
end

function love.threaderror(thread, errorMessage)
    print("Thread error!\n" .. errorMessage, thread)
    love.window.showMessageBox("Error", errorMessage, "error")
end
