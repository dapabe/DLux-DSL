local lfs = love.filesystem

local Watcher = {}
Watcher.__index = Watcher

local ignorePatterns = {
    "^%.git/",
    "^hmr/",
    "%.png$",
    "%.jpg$",
    "%.mp3$",
    "%.ogg$",
}

local function shouldIgnore(path)
    for _, pat in ipairs(ignorePatterns) do
        if path:match(pat) then return true end
    end
    return false
end

local function scan(path, out)
    out = out or {}
    for _, item in ipairs(lfs.getDirectoryItems(path)) do
        local full = path .. "/" .. item
        if not shouldIgnore(full) then
            local info = lfs.getInfo(full)
            if info then
                if info.type == "file" then
                    out[full] = info.modtime
                elseif info.type == "directory" then
                    scan(full, out)
                end
            end
        end
    end
    return out
end

function Watcher.new(root, interval)
    return setmetatable({
        root = root or "",
        interval = interval or 0.3,
        timer = 0,
        snapshot = scan(root or "")
    }, Watcher)
end

function Watcher:update(dt)
    self.timer = self.timer + dt
    if self.timer < self.interval then return end
    self.timer = 0

    local new = scan(self.root)

    for p, t in pairs(new) do
        local old = self.snapshot[p]
        if not old or old ~= t then
            self.snapshot = new
            return p
        end
    end

    self.snapshot = new
    return nil
end

return Watcher
