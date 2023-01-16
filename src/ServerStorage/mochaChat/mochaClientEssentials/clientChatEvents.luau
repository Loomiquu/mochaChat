local mochaDependencies = script.Parent:WaitForChild("mochaDependencies")
local defaultFallBackColor = mochaDependencies:WaitForChild("robloxChatColor")

local clientEvents = {}

function clientEvents:invokedMessage(messageData)
    local userColor = self:GetUserColorIndex()
    if not userColor:IsA("ModuleScript") then userColor = defaultFallBackColor end
    if not messageData.Player:IsA("Player") then warn("instance is not a player") return end
    local colorModule = require(userColor)

    colorModule:GenerateColor(messageData.Player) 
end

return clientEvents