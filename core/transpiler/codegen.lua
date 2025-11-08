local Codegen = {}

---@param exp Token
function Codegen._NumberLiteral(exp)
  return exp.value
end
---@param exp Token
function Codegen._StringLiteral(exp)
    return string.format('"%s"', exp.value)
end
---@param exp Token
function Codegen._FunctionLiteral(exp)
  -- Replace standalone fn followed by (...) with function
  local formatted = exp.value
    :gsub("(%f[%w_])fn%s+([%a_][%w_]*)%s*(%b())", "function %2%3")
    :gsub("(%f[%w_])fn(%s*%b())", "function%2")
  return formatted
end

--  function Codegen ._emitNode(node)
--   if node.name == "__text" then
--     return string.format("q.Text{ value=%q }", node.value)
--   end

--   local attrs = {}
--   for k,v in pairs(node.attrs or {}) do
--     table.insert(attrs, k .. "=" .. v)
--   end
--   local children = {}
--   for _,c in ipairs(node.children or {}) do
--     table.insert(children, emit_node(c))
--   end

--   local args = table.concat(attrs, ", ")
--   if #children > 0 then
--     if #args > 0 then args = args .. ", " end
--     args = args .. "children={" .. table.concat(children, ",") .. "}"
--   end

--   return string.format("q.%s{%s}", node.name, args)
-- end

-- local out = {ast.lua_block}
-- for _,c in ipairs(ast.components) do
--   table.insert(out, "return " .. emit_node(c))
-- end
-- return table.concat(out, "\n")

---@param exp Token
local function genExpression(exp)
  local validToken = Codegen["_"..exp.type]
  assert(validToken, string.format('Unexpected or unsupported expression: "%s"', exp.type))
  return validToken(exp)
end

---@param exp Token
function Codegen.generate(exp)
  return genExpression(exp)
end

return Codegen
