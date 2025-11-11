local luarocks_path = "/usr/local/share/lua/5.1/?.lua;" ..
                      "/usr/local/share/lua/5.1/?/init.lua;"
local luarocks_cpath = "/usr/local/lib/lua/5.1/?.so;"

package.path = package.path .. ";" .. luarocks_path
package.cpath = package.cpath .. ";" .. luarocks_cpath

local yoga = require("luyoga")

local root = yoga.Node.new()
root.style:setFlexDirection(yoga.Enums.FlexDirection.Row)
root.style:setWidth(love.graphics.getWidth())
root.style:setHeight(100)

local child = yoga.Node.new()

function love.load()
  child.style:setFlexGrow(1)
  child.style:setMargin(yoga.Enums.Edge.Right, 1)
  root:insertChild(child, 0)
  root:calculateLayout(nil, nil, yoga.Enums.Direction.LTR)
  -- TLux.bootstrap("out.lua")
end


function love.update(dt)
  -- TLux.update(dt)
end

function love.draw()
  
  love.graphics.rectangle("fill", child.layout:getLeft(), child.layout:getTop(), child.layout:getWidth(), child.layout:getHeight())
  -- TLux.draw()
end
