-- local parser = require("tlux.transpiler.parser")
local codegen = require("transpiler.codegen")

local Transpiler = {}

---@param exp string
---@return boolean
function Transpiler._isNumber(exp)
  if type(exp) ~= "string" and type(exp) ~= "number" then
      return false
  end
  return tonumber(exp) ~= nil
end
---@param exp string
---@return boolean
function Transpiler._isString(exp)
    if type(exp) ~= "string" then
        return false
    end
    return (exp:sub(1,1) == '"' and exp:sub(-1) == '"')
        or (exp:sub(1,1) == "'" and exp:sub(-1) == "'")
end
---@param exp string
---@return boolean
function Transpiler._isFunctionLiteral(exp)
    if type(exp) ~= "string" then return false end
    -- must start with `fn`
    if not exp:match("^%s*fn%s*%b()") then return false end

    -- temporarily rewrite for syntax check
    local lua_code = exp:gsub("^%s*fn", "function", 1)

    local f = load(lua_code, "test", "t", {})
    if not f then return false end

    -- ensure original text didn’t contain Lua’s 'function' keyword
    if exp:find("%f[%a]function%f[%A]") then return false end
    return true
end

---@param raw string
---@return Token
local function getAbstractSyntaxTree(raw)
  
  if Transpiler._isNumber(raw) then return {type = "NumberLiteral", value = tonumber(raw)} end
  if Transpiler._isString(raw) then return {type = "StringLiteral", value = raw} end
  if Transpiler._isFunctionLiteral(raw) then return {type = "FunctionLiteral", value = raw} end

  error(string.format("Unexpected expression: %s", raw))
end

--- Transpiles TLux program to Lua code
---@param raw any
---@return {AST: Token, lua_code: string}
function Transpiler.transpile(raw)

  local LuaAST = getAbstractSyntaxTree(raw)
  local lua_code = codegen.generate(LuaAST)

  return {AST = LuaAST, lua_code = lua_code}
end

return Transpiler
