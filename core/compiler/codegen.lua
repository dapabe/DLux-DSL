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
