local Patcher = {}

local function shallowCopy(t)
    local n = {}
    for k,v in pairs(t) do n[k] = v end
    return n
end

function Patcher.patch(old, new)
    for k,v in pairs(new) do
        if type(v) == "function" then
            old[k] = v         -- hot swap
        elseif type(v) == "table" then
            if type(old[k]) == "table" then
                Patcher.patch(old[k], v)
            else
                old[k] = shallowCopy(v)
            end
        end
    end
end

return Patcher
