
---@class DSLCompiler
local DSLCompiler = {}


---@param parts table
---@param path string
---@param framework_env table
---@return table
function DSLCompiler.eval(parts, path, framework_env)
    assert(type(parts) == "table", "expected parts table")
    assert(type(framework_env) == "table", "expected framework environment")

    ------------------------------------------------------------------------
    -- 1. STATIC BLOCK
    ------------------------------------------------------------------------
    local env_static = setmetatable({}, { __index = framework_env })
    env_static._G = env_static
    env_static.print = print

    local chunk_static, err1 = load(parts.static_src, "@" .. path .. ":static", "t", env_static)
    if not chunk_static then
        error(("DSLCompiler: syntax error in static block of %s\n%s"):format(path, err1))
    end

    local ok, exec_err = pcall(chunk_static)
    if not ok then
        error(("DSLCompiler: runtime error in static block of %s\n%s"):format(path, exec_err))
    end

    ------------------------------------------------------------------------
    -- 2. LUA_MATTER BLOCK
    ------------------------------------------------------------------------
    local fm_fn
    if parts.fm_src and #parts.fm_src > 0 then
        -- envolvemos el front-matter como función(Outer)
        local wrapped = "return function(Outer)\n" .. parts.fm_src .. "\nend"
        local chunk_fm, err2 = load(wrapped, "@" .. path .. ":lua_matter", "t", env_static)
        if not chunk_fm then
            error(("DSLCompiler: syntax error in lua_matter of %s\n%s"):format(path, err2))
        end

        local ok2, fn_or_err = pcall(chunk_fm)
        if not ok2 then
            error(("DSLCompiler: runtime error in lua_matter of %s\n%s"):format(path, fn_or_err))
        end

        fm_fn = fn_or_err
    else
        -- bloque vacío
        fm_fn = function() return {} end
    end

    ------------------------------------------------------------------------
    -- 3. LUA_XML BLOCK (solo se guarda texto sin parsear)
    ------------------------------------------------------------------------
    local xml_src = parts.xml_src or ""

    ------------------------------------------------------------------------
    -- 4. RESULTADO
    ------------------------------------------------------------------------
    return {
        env_static = env_static,
        fm_fn = fm_fn,
        xml_src = xml_src,
        meta = parts.meta
    }
end

return DSLCompiler