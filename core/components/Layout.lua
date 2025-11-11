
local Layout = {}

-- ---@param node UINode
-- ---@param parentWidth number
-- ---@param parentHeight number
-- ---@param offsetX? number
-- ---@param offsetY? number
-- function Layout.compute(node, parentWidth, parentHeight, offsetX, offsetY)
--   offsetX = offsetX or 0
--   offsetY = offsetY or 0
--   node.color = node.color or {0, 0, 0, 0}
--   node._computed = {width = 0, height = 0, x = 0, y = 0}

--   local dir = node.flexDirection or "row"
--   local isRow = dir == "row"
  
--   local justify = node.flexJustify or "start"
--   local align = node.flexAlign or "stretch"

--   -- Calculate occupied space and total flex
--   local totalFlex, usedSpace = 0, 0
--   for _, child in ipairs(node.children or {}) do
--     child._computed = {} -- Declaring here the computed field
--     if child.size.flexGrow then
--       totalFlex = totalFlex + child.size.flexGrow
--     else
--       usedSpace = usedSpace + (isRow and (child.size.width or 0) or (child.size.height or 0))
--     end
--   end

--   local containerMain = isRow and parentWidth or parentHeight
--   local containerCross = isRow and parentHeight or parentWidth

--   local remaining = containerMain - usedSpace
--   local flexUnit = totalFlex > 0 and (remaining / totalFlex) or 0

--   -- Calculate size
--   local totalSize = 0
--   for _, child in ipairs(node.children or {}) do
--     local s = child.size or {}
--     if isRow then
--       child._computed.width = s.width or (s.flexGrow and flexUnit * s.flexGrow) or 0
--       child._computed.height = s.height or containerCross
--       totalSize = totalSize + child._computed.width
--     else
--       child._computed.height = s.height or (s.flexGrow and flexUnit * s.flexGrow) or 0
--       child._computed.width = s.width or containerCross
--       totalSize = totalSize + child._computed.height
--     end
--   end

--   -- Calculate initial space and separation
--   local startOffset, spacing = 0, 0
--   if justify == "center" then
--     startOffset = (containerMain - totalSize) / 2
--   elseif justify == "end" then
--     startOffset = containerMain - totalSize
--   elseif justify == "between" and #node.children > 1 then
--     spacing = (containerMain - totalSize) / (#node.children - 1)
--   elseif justify == "around" then
--     spacing = (containerMain - totalSize) / #node.children
--     startOffset = spacing / 2
--   end

--   -- Calculate position
--   local cursor = startOffset
--   for _, child in ipairs(node.children) do
--     local cx, cy

--     if isRow then
--       cx = offsetX + cursor
--       cy = offsetY
--       if align == "center" then
--         cy = offsetY + (containerCross - child._computed.height) / 2
--       elseif align == "end" then
--         cy = offsetY + (containerCross - child._computed.height)
--       end
--       child._computed = { x = cx, y = cy, width = child._computed.width, height = child._computed.height }
--       cursor = cursor + child._computed.width + spacing
--     else
--       cx = offsetX
--       cy = offsetX + cursor
--       if align == "center" then
--         cx = offsetX + (containerCross - child._computed.width) / 2
--       elseif align == "end" then
--         cx = offsetX + (containerCross - child._computed.width)
--       end
--       child._computed = { x = cx, y = cy, width = child._computed.width, height = child._computed.height }
--       cursor = cursor + child._computed.height + spacing
--     end

--     if child.children then
--       Layout.compute(child, child._computed.width, child._computed.height, child._computed.x, child._computed.y)
--     end
--   end
-- end

function Layout.compute()
end

---@param node UINode
function Layout.drawNode(node)

  if node.type == "View" then
    love.graphics.setColor(node.color)
    love.graphics.rectangle("fill",
      node._computed.x, node._computed.y,
      node._computed.width, node._computed.height
    )
  end

  if node.type == "Box" then
    love.graphics.setColor(node.color)
    love.graphics.rectangle("fill",
      node._computed.x, node._computed.y,
      node._computed.width, node._computed.height
    )
  end

  for _, child in ipairs(node.children or {}) do
    Layout.drawNode(child)
  end
end


return Layout