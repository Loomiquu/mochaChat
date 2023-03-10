local serverStorage = game:GetService("ServerStorage")
local mochaPrintStack = require(script.Parent:WaitForChild("mochaPrintStack"))

---@class listeners
local hooks = {}
local OnPlayerChatted = {}
OnPlayerChatted.__index = OnPlayerChatted

local RBXScriptConnection = {}
RBXScriptConnection.__index = RBXScriptConnection
RBXScriptConnection.Connected = true

function RBXScriptConnection:Disconnect()
    if typeof(self[1]) ~= "Instance" then warn("Possible Memory Leak Detected") return end
    if not self[1]:IsA("BindableFunction") then warn("Possible Memory Leak Detected") return end
    self[1]:Destroy()
    self.Connected = false
end

---@param functionParams function
---@return RBXScriptConnection
function OnPlayerChatted:Connect(functionParams)
    local listenerHolder = serverStorage:FindFirstChild("ListenerHolder")
    if type(functionParams) ~= "function" then mochaPrintStack.printErrorStack(501) end
    if listenerHolder == nil then mochaPrintStack.printErrorStack(502) end

    local listenerInstance = Instance.new("BindableFunction")
    listenerInstance.Name = "OnPlayerChatted"
    listenerInstance.Parent = listenerHolder

    local listener = {listenerInstance}

    listenerInstance.OnInvoke = function(mochaChatInstance, chatInfo)
        local player = chatInfo.Player
        local message = chatInfo.Message
        functionParams(player, message)
    end

    return setmetatable(listener, RBXScriptConnection)
end

hooks["OnPlayerChatted"] = setmetatable({}, OnPlayerChatted)


return hooks 