---@type UINode
local tree = {
  type = "View",
  flexDirection = "row",
  color = {1,.3,1},
  size = {width = 20, height = 40},
  -- flexJustify = "center",
  children = {
    { type = "Box", size = { flexGrow = 1 }, color = { 1, 0, 0 } },
    {
      type = "Box",
      flexJustify = "end",
      flexAlign = "end",
      size = { flexGrow = 1, height = 200, },
      color = { .2, 1, 0 },
      children = {
        { type = "Box", size = { width = 30, height = 50 }, color = { .2, .2, .3 } }
      }

    },
    {
      type = "Box",
      size = { flexGrow = 1 },
      color = { 1, 1, .5 },
      flexJustify = "center",
      flexAlign = "center",
      children = {
        { type = "Box", size = { width = 50, height = 200 }, color = { .2, .7, .7 } }
      }
    }
  }
}

return tree
