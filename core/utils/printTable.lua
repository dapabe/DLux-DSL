
local formatting
_G.printTable = function(tbl, indent)
  if not indent then indent = 1 end
  print("{")
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      printTable(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
  print("}")
end
