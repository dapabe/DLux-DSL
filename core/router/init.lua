

local Router = {}


function Router.load(rootDir)
    local list = love.filesystem.getDirectoryItems(rootDir)

    for _, path in ipairs(list) do
        print(path)
        Manager.new()
    end

    -- local f = assert(io.open(rootDir, "r"))
    -- local src = f:read("*a")
    -- f:close()

    -- local ast = parser:produceAST(src)
    -- local lua = codegen.generate(ast)

    -- local chunk, err = load(lua, path)
    -- if not chunk then error(err) end
    -- return chunk()
end

Router.load(...)

return Router

