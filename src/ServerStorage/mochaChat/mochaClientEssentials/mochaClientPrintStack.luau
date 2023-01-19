local mochaStack = {}

local warnStacks = {
    [600] = function(value)
        warn(("Missing value, defaulting to mochaChat default chat"):gsub("value", value))
    end,
    [601] = function(_)
        warn("No UI currently available, cannot destroy")
    end,

}

local errorStacks = {
    [600] = function()
        error("User is on console, Terminating Client Instance", 0) -- For context, mochaChat is never being supported on console
    end
}

function mochaStack.printWarnStack(errorCode, extraStackInfo) --Doesnt stop the running script,(Used in most cases)
    pcall(function() warnStacks[errorCode](extraStackInfo) end)
end

function mochaStack.printErrorStack(errorCode) --Stops the running script, (DO NOT USE AFTER INITIAL RUN-TIME)
    errorStacks[errorCode]()
end

return mochaStack