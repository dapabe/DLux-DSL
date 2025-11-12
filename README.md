
# DLux(Deluxe) Lang
Long term: Design for Lua user experiences

A superset of Lua based on XML-like GUI syntax and FrontMatter declarations specialized for File-Based-Routing.

Used on top of the Love2D framework with native component primitives, heavely inspired by the Astro framework and React Native.

To use this programming language first you will have create and respect this directory structure:

```md
rootDir
├── routes
|   ├── dashboard
|   |   ├── index.dlux
|   ├── root.dlux
|   ├── layout.dlux
|   ├── index.dlux or game.dlux
├── conf.lua
├── main.lua
```

First create this file `routes/root.dlux` and paste this block of code
```dlux
---
local name = "Deluxe"
local count, increment = useState(0, fn(current, prev) 
    return current + 1
end)

@OnEnter={fn()

end}

---
<Root>
    <Text>name</Text>
    <Button
        onClick={fn() increment() end}
    >
    count
    </Button>
</Root>
```

## Scope
- Tokenizer Module: Done
- Parsing Module: WIP
- Abstract Syntax Trees: WIP
- Predictive parser: WIP
- Syntax: Language-agnostic parser generator
- Left recursion
- Simple expression: number and strings
- Variable declarations
- Blocks
- Group expresion 

### Features

- Lua's built-in
  - Binary
  - Logical
  - Branches: if-else-expression
  - Loops: while, for-loop
  - Lambda: anonymous closures
  - Operator precedence
  - Parsing classes and modules
  - Property access
  - Function calls
- FrontMatter (LuaMatter) code blocks, inspired by Astro Framework.
- XML component syntax, inspired by React Native.
- File Based Routing [WIP]
- File Route Events [WIP]

## How does this work?

Firstly the compiler transpiles the `.dlux` files into its Lua's counterpart and separates the **LuaMatter** fron the components then the **code generator** injects the element creation on top of the file, just like React does. \
Example: `createElement("View", props, children)`