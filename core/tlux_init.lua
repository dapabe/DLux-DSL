-- require("tlux.utils.enums")
-- require("tlux.transpiler.ast")
require("utils.printTable")

local transpiler = require("transpiler.init")
-- local Queue = require("tlux.components.factory")[1]

local TLux = {}
local root

-- function TLux.bootstrap(entry)
--   root = compiler.load(entry)
-- end

-- function TLux.draw()
--   Queue.reset()
--   if root and root.draw then root:draw() end
--   for _, f in ipairs(Queue.get()) do f() end
-- end

local raw = [[
local add = fn(a, b) return a + b end
local id = fn(x)
  return x
end
]]

local transpiled = transpiler.transpile(raw)

print("\n AST")
printTable(transpiled.AST)
print("\n Code")
print(transpiled.lua_code)

