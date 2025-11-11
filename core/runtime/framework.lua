local Framework = {}

---@type {[string]: Component}
local knownComponents = {}

-- Global state & components
local prevTree = nil
local stateStore = {}
local hooksIndex = 0
local currentKey = nil

---@generic State
---@param initial State
---@return State
---@return fun(newState: State)
function Framework.useState(initial)
    hooksIndex = hooksIndex + 1
    local key = currentKey .. ":" .. hooksIndex
    if stateStore[key] == nil then stateStore[key] = initial end
    local function set(v)
        stateStore[key] = v
    end
    return stateStore[key], set
end

function Framework.rootRender(component, props)
    hooksIndex = 0
    currentKey = tostring(component)
    return component(props or {})
end

-- Reconciliation
local function sameProps()
    for k, v in pairs(a) do
        if b[k] ~= v then return false end
    end
    for k, v in pairs(b) do
        if a[k] ~= v then return false end
    end
    return true
end

---@param a Component
---@param b Component
local function patch(a, b)
    if a.type ~= b.type then
        unmount(a)
        mount(b)
        return
    end

    -- actualizar props
    for k, v in pairs(b.props) do
        if a.props[k] ~= v then
            update_prop(a, k, v)
        end
    end

    -- recursión sobre hijos
    local ac, bc = a.children or {}, b.children or {}
    local len = math.max(#ac, #bc)
    for i = 1, len do
        if ac[i] and bc[i] then
            patch(ac[i], bc[i])
        elseif bc[i] then
            mount(bc[i])
        elseif ac[i] then
            unmount(ac[i])
        end
    end
end

local function updateTree(root)
    if not prevTree then
        prevTree = root
    else
        prevTree = patch(prevTree, root)
    end
end

---@param component Component
function Framework.addComponent(component)
    knownComponents[component.props.type] = component
end

---@param component Component | nil
function Framework.draw(component)
    if not component then return end
    local key = component.props.type
    if knownComponents[key] then
        if knownComponents[key]._draw then knownComponents[key]:_draw() end
    end
    for _, c in ipairs(component.children) do
        Framework.draw(c)
    end
end

return Framework
