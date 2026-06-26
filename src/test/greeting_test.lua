local greeting = require("greeting")

local function main()
    local result = greeting.greet("Wippy")
    if result ~= "Hello, Wippy!" then
        error("expected 'Hello, Wippy!', got '" .. tostring(result) .. "'")
    end

    return true
end

return { main = main }
