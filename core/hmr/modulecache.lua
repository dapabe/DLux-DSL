local ModuleCache = {}

function ModuleCache.invalidate(path)
    for k,_ in pairs(package.loaded) do
        if k == path or k:match(path .. "$") then
            package.loaded[k] = nil
        end
    end
end

return ModuleCache
