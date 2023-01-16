local mochaStack = {}

local warnStacks = {
    [500] = function()
        warn("Provided value is not a player Type or int type, Mute/UnMute has been denied")
    end,
    [501] = function()
        warn("Client does not permission to commit ServerSide changes")
    end,
    [502] = function()
        warn("Provided value is nil, Mute/UnMute has been denied")
    end,
    [503] = function()
        warn("Duplicate Mute/Unmute target detected, dropping task")
    end
}

local errorStacks = {
    [500] = function()
        error("MochaChat Security Error: Do not parent MochaScript outside of ServerStorage", 0)
    end,
    [501] = function()
        error("Given parameter is not a function type, please provide a function type", 0)
    end,
    [502] = function()
        error("Missing listenerHolder, [Do not destroy this instance!]", 0)
    end
}

function mochaStack.printWarnStack(errorCode) --Doesnt stop the running script,(Used in most cases)
    pcall(function() warnStacks[errorCode]() end)
end

function mochaStack.printErrorStack(errorCode) --Stops the running script, (DO NOT USE AFTER INITIAL RUN-TIME)
    errorStacks[errorCode]()
end

return mochaStack