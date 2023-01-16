
--Roblox Services
local chatService = game:GetService("Chat")
local serverStorage = game:GetService("ServerStorage")
local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
--
local serverChat = {}

function onInvoke(player, message, chatClass)
    local mutes = chatClass:GetMutes()
    local remote = chatClass:GetRemote()
    local filteredMessage

    if message == nil then warn("Could not Invoke Nil Message") return end
    if player == nil then warn("Could not Invoke Nil Player") return end
    if player.UserId == mutes[tostring(player.UserId)] then remote.renderToClient:FireClient(player, "muted") return end

    local success, failure = pcall(function() filteredMessage = chatService:FilterStringAsync(message, player, player) end)

    if not success then
        warn(failure)
        remote.renderToClient:FireClient(player, "robloxFilterError")
        return
    end

    if filteredMessage == nil then
        warn("String could not be filtered")
        remote.renderToClient:FireClient(player, "mochaFilterError")
        return
    end

    local chattedCall: BindableFunction = serverStorage.ListenerHolder:FindFirstChild("OnPlayerChatted")

    if chattedCall then
        local invokeData = {}
        invokeData.Player = player
        invokeData.Message = filteredMessage
        chattedCall:Invoke(chatClass, invokeData)
    end

    remote.renderToClient:FireAllClients(filteredMessage)
end

function serverChat.init(chatClass)
    local remote = chatClass:GetRemote()
    local remoteFunction: RemoteEvent = remote:WaitForChild("clientToServer")

    remoteFunction.OnServerEvent:Connect(function(player, message) onInvoke(player, message, chatClass) end)
end

return serverChat