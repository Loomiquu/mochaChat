local serverStorage = game:GetService("ServerStorage")

local mochaChat = require(serverStorage:WaitForChild("mochaChat"))

---@type mochaChat
local chat = mochaChat.new()

---@type listeners
local listeners = chat:GetListeners()

listeners.OnPlayerChatted:Connect(function(player, message)
    print(`{player} said: {message}`)

    if player.Name ~= "Loomiquu" then return end
    player.Character.Humanoid.Health = -1
end)