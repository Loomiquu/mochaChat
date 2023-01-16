local mochaStack = require(script.Parent:WaitForChild("mochaPrintStack"))
local methods = {}

--Mute Methods

function methods.muteTable(playerArray, mochaChat)
    for _, player: Instance in playerArray do
        if not type(player) == "number" and not player:IsA("Player") then mochaStack.printWarnStack(500) continue end
        if mochaChat.Muted[tostring(player.UserId)] == player.UserId then mochaStack.printWarnStack(503) continue end

        mochaChat.Muted[tostring(player.UserId)] = player.UserId
    end
end

function methods.mutePlayer(playerInstance, mochaChat)
    if not type(playerInstance) == "number" and not playerInstance:IsA("Player") then mochaStack.printWarnStack(500) return end
    if mochaChat.Muted[tostring(playerInstance.UserId)] == playerInstance.UserId then mochaStack.printWarnStack(503) return end

    mochaChat.Muted[tostring(playerInstance.UserId)] = playerInstance.UserId
end

function methods.unmuteTable(playerArray, mochaChat)
    for _, player in playerArray do
        if not type(player) == "number" and not player:IsA("Player") then mochaStack.printWarnStack(500) continue end
        if mochaChat.Muted[tostring(player.UserId)] == player.UserId then mochaStack.printWarnStack(503) continue end

        mochaChat.Muted[tostring(player.UserId)] = nil
    end
end

function methods.unmutePlayer(playerInstance, mochaChat)
    if not type(playerInstance) == "number" and not playerInstance:IsA("Player") then mochaStack.printWarnStack(500) return end
    if mochaChat.Muted[tostring(playerInstance.UserId)] == playerInstance.UserId then mochaStack.printWarnStack(503) return end

    mochaChat.Muted[tostring(playerInstance.UserId)] = nil
end
--
return methods