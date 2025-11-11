package.path = package.path .. ";../?.lua;../?/init.lua"

-- require("tlux.utils.enums")
-- require("tlux.transpiler.ast")
-- require("utils.printTable")

-- local transpiler = require("transpiler.init")
local Watcher = require("core.Watcher")
local Layout = require("core.components.Layout")

local TLux = {}

local raw = [[
local add = fn(a, b) return a + b end
local id = fn(x)
  return x
end
]]

-- local transpiled = transpiler.transpile(raw)

-- print("\n AST")
-- printTable(transpiled.AST)
-- print("\n Code")
-- print(transpiled.lua_code)
local tree

local _layout

function TLux.bootstrap(dirPath)
  print("[TLux] Init")
  Watcher.track("components/Layout.lua", function ()
    package.loaded["_layout"] = nil
    _layout = dofile("components/Layout.lua")
  end)
  Watcher.track(dirPath, function()
    package.loaded["tree"] = nil
    tree = dofile(dirPath)
  end)
  Layout.compute(tree, love.graphics.getWidth(), love.graphics.getHeight())
end

function TLux.update(dt)
  Watcher.update()
  if tree then
  end
end

function TLux.draw()
  if tree then
    -- Layout.drawNode(tree)
  end
end


return TLux