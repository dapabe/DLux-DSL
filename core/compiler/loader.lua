local lfs = love.filesystem

---@class DSLLoader 
local Loader = {}

local function file_exists(path)
    local f = io.open(path, "r")
    if f then f:close(); return true end
    return false
end

local function get_mtime(path)
    return lfs.getInfo(path, "file").modtime
end

---@param path string
---@return { path: string, name: string, dir: string, content: string, mtime: number }
function Loader.load(path)
    assert(type(path) == "string", "expected 'path'to be string")

    if not file_exists(path) then
        error("DSLLoader: file not found "..path)
    end

    local f = io.open(path, "r")
    if not f then error("DSLLoader: file could not be open "..path) end
    local content = f:read("*a")
    f:close()

    local abs = path:gsub("\\", "/")
    local name = abs:match("([^/]+).dlux$")
    local dir = abs:match("(.+)/[^/]+$") or "."

    return {path = abs, name = name, dir = dir, content = content, mtime = get_mtime(path)}
end

return Loader