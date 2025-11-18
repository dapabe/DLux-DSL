local Cache = require("core.hmr.ModuleCache")
local Patcher = require("core.hmr.Patcher")

local Refresh = {}

-- donde guardamos instancias vivas
Refresh.instances = {}

-- llamado desde tus componentes al crearse
function Refresh.registerInstance(instance, modulePath)
    Refresh.instances[modulePath] = Refresh.instances[modulePath] or {}
    table.insert(Refresh.instances[modulePath], instance)
end

function Refresh.reload(modulePath)
    Cache.invalidate(modulePath)

    local ok, newModule = pcall(require, modulePath)
    if not ok then
        print("[HMR] Error loading " .. modulePath .. ": " .. tostring(newModule))
        return
    end

    print("[HMR] Module patched:", "<rootDir>" .. modulePath)

    -- patch a todas las instancias
    local instances = Refresh.instances[modulePath]
    if instances then
        for _, inst in ipairs(instances) do
            Patcher.patch(inst, newModule)
        end
    end
end

return Refresh
