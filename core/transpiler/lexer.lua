
---@class Token
---@field type TokenType
---@field value string



local Lexer = {}

---@param code string
---@return Token[]
function Lexer.tokenize(code)
    ---@type Token[]
    local tokens = {}
    local src = code:sub("")
    
    -- Produce tokens until EndOfFile is reached
    while #src > 0 do
        
    end
    
    table.insert(tokens, {type = TokenType["EndOfFile"], value = "EndOfFile"} --[[@as Token]])
    return tokens
end

return Lexer