--[[
-----------------------------------
--- Components
]]
---@alias SizeFactor {width: number, height: number} | {flexGrow: integer}

---@class UILayoutPrimitive
---@field x? number
---@field y? number
---@field padding? number | table<number, number> | table<number, number, number, number> # All sides | Vertical/horizontal | All sides independently
---@field size? SizeFactor

---@class UINode: UILayoutPrimitive
---@field type string # Name of the node/component
---@field color? table<number, number, number, number>
---@field flexDirection? "row" | "column"
---@field flexJustify?  "start" | "center" | "end" | "between" | "around"
---@field flexAlign? "start" | "center" | "end" | "stretch"
---@field _computed? {x: number, y: number, width: number, height: number}
---@field children? UINode[]

---@class Component
---@field props UINode
---@field children Component[]
---@field _update? fun(self: self)
---@field _draw? fun(self: self)

--[[
-----------------------------------
--- Compiler
]]

---@alias TokenType
--- | "Program"
--- | "NumberLiteral"
--- | "StringLiteral"
--- | "BooleanLiteral"
--- | "Identifier"

---@class Statement
---@field kind TokenType

---@class StmtProgram: Statement
---@field kind "Program"
---@field body Statement[]

---@class Expression: Statement

---@class ExprBinary: Expression
---@field left Expression
---@field right Expression
---@field operator string

---@class ExprNumberLiteral: Expression
---@field kind "NumberLiteral"
---@field value number

---@class ExprStringLiteral: Expression
---@field kind "StringLiteral"
---@field value string