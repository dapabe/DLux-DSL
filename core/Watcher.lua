local lfs = love.filesystem
local Watcher = {}
Watcher.tracked = {}

function Watcher.track(path, onChange)
  Watcher.tracked[path] = { time = lfs.getInfo(path), cb = onChange }
end

function Watcher.update()
  for path, data in pairs(Watcher.tracked) do
    local t = lfs.getInfo(path)
    if t and t ~= data.time then
      data.time = t
      data.cb()
    end
  end
end

return Watcher
