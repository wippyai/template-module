local greeting = require("greeting")
local test = require("test")

local function define_tests()
    test.describe("Greeting", function()
        test.it("greets the requested name", function()
            test.eq(greeting.greet("Wippy"), "Hello, Wippy!")
        end)
    end)
end

return { run = test.run_cases(define_tests) }
