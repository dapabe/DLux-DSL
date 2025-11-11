
---@class DSLPreprocessor
local Preprocessor = {}

-- Pattern: local ClassName extends BaseClass
local EXTENDS_PATTERN = "^%s*local%s+([%w_]+)%s+extends%s+([%w_%.]+)%s*$"

---@param static_block string
---@return string processed_block
function Preprocessor.run(static_block)
  assert(type(static_block) == "string", "expected static source string")

    local output = {}
    local line_num = 0

    for line in static_block:gmatch("([^\n]*)\n?") do
        line_num = line_num + 1

        local name, base = line:match(EXTENDS_PATTERN)
        if name and base then
            table.insert(output, ("local %s = %s:extend()"):format(name, base))
        else
            table.insert(output, line)
        end
    end

    return table.concat(output, "\n")
end

return Preprocessor