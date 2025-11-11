
---@class Token
---@field type TokenType
---@field value string


---@class DSLLexer
local Lexer = {}


---@param src string
---@param path string
---@return { static_block: string, lua_matter_block: string, xml_block: string, meta: table }
function Lexer.split(src, path)
    assert(type(src) == "string", "expected source string")

    local static_block, lua_matter_block, xml_block = "", "", ""
    ---@type "static" | "lua_matter" | "xml"
    local part = "static"
    local line_num = 0
    local meta = { static_start = 1, lm_start = nil, xml_start = nil }

    for line in src:gmatch("([^\n]*)\n?") do
        line_num = line_num + 1

        if line:match("^%s*###%s*$") then
            if part == "static" then
                part = "lua_matter"
                meta.lm_start = line_num + 1
            elseif part == "lua_matter" then
                part = "xml"
                meta.xml_start = line_num + 1
            else
                error(("DSLLexer: unexpected '###' at line %d in %s"):format(line_num, path or ""))
            end
        else
            if part == "static" then
                static_block = static_block .. line .. "\n"
            elseif part == "lua_matter" then
                lua_matter_block = lua_matter_block .. line .. "\n"
            elseif part == "xml" then
                xml_block = xml_block .. line .. "\n"
            end
        end
    end

    if not meta.lm_start or not meta.xml_start then
        error(("DSLLexer: missing required delimiters in %s"):format(path or ""))
    end

    meta.lines_total = line_num

    return {
        static_block = static_block,
        lua_matter_block = lua_matter_block,
        xml_block = xml_block,
        meta = meta
    }
end

---@param s string
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

---@param src string
---@param path string
---@return table
function Lexer.tokenize(src, path)
    assert(type(src) == "string", "expected XML source string")

    local pos = 1
    local line = 1
    local stack = {}
    local root = { type = "Root", children = {} }
    local current = root

    while pos <= #src do
        local tag_start, tag_end, tag_content = src:find("<([^>]+)>", pos)

        if not tag_start then
            local text = trim(src:sub(pos))
            if #text > 0 then
                table.insert(current.children, { type = "Text", value = text, line = line })
            end
            break
        end

        -- texto antes del tag
        local pre_text = trim(src:sub(pos, tag_start - 1))
        if #pre_text > 0 then
            table.insert(current.children, { type = "Text", value = pre_text, line = line })
        end

        -- actualizar línea
        for _ in src:sub(pos, tag_end):gmatch("\n") do
            line = line + 1
        end

        local tag_inner = trim(tag_content)

        -- cierre de tag
        if tag_inner:match("^/") then
            local closing_tag = tag_inner:match("^/%s*([%w_]+)")
            if not current or current.tag ~= closing_tag then
                error(("XMLParser: mismatched closing tag </%s> at line %d in %s")
                    :format(closing_tag or "?", line, path or "?"))
            end
            current = table.remove(stack) or root

        -- apertura o autocierre
        else
            local self_closing = tag_inner:match("/%s*$")
            if self_closing then
                tag_inner = tag_inner:gsub("/%s*$", "")
            end

            local tag_name, attrs = tag_inner:match("^([%w_]+)%s*(.*)$")
            if not tag_name then
                error(("XMLParser: invalid tag syntax at line %d in %s"):format(line, path or "?"))
            end

            local node = { type = "Element", tag = tag_name, props = {}, children = {}, line = line }

            -- parse attributes
            for key, val in attrs:gmatch("([%w_]+)%s*=%s*([^\n%s]+)") do
                node.props[key] = val
            end

            table.insert(current.children, node)

            if not self_closing then
                table.insert(stack, current)
                current = node
            end
        end

        pos = tag_end + 1
    end

    if #stack > 0 then
        local unclosed = stack[#stack].tag or "?"
        error(("XMLParser: unclosed tag <%s> in %s"):format(unclosed, path or "?"))
    end

    return root
end

return Lexer