local Cache = require("modulecache")
local Patcher = require("patcher")

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
        print("[HMR] Error cargando " .. modulePath .. ": " .. tostring(newModule))
        return
    end

    print("[HMR] Patcheando módulo:", modulePath)

    -- patch a todas las instancias
    local instances = Refresh.instances[modulePath]
    if instances then
        for _,inst in ipairs(instances) do
            Patcher.patch(inst, newModule)
        end
    end
end

return Refresh
