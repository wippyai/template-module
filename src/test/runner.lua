local io = require("io")
local registry = require("registry")
local funcs = require("funcs")

local function run_one(id)
    local ok, result, err = pcall(function()
        return funcs.call(id)
    end)

    if not ok then
        return false, tostring(result)
    end

    if err then
        return false, tostring(err)
    end

    if result == false then
        return false, "test returned false"
    end

    return true, nil
end

local function main()
    local entries, err = registry.find({ ["meta.type"] = "test" })
    if err then
        io.print("registry error: " .. tostring(err))
        return 1
    end

    if not entries or #entries == 0 then
        io.print("no tests found")
        return 0
    end

    local passed = 0
    local failed = 0

    for _, entry in ipairs(entries) do
        local ok, message = run_one(entry.id)
        if ok then
            passed = passed + 1
            io.print("PASS " .. entry.id)
        else
            failed = failed + 1
            io.print("FAIL " .. entry.id .. ": " .. tostring(message))
        end
    end

    io.print("")
    io.print(tostring(passed) .. " passed, " .. tostring(failed) .. " failed")

    if failed > 0 then
        return 1
    end

    return 0
end

return { main = main }
