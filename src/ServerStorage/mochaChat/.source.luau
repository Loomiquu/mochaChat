--Mocha Services
local mochaMethods = require(script:WaitForChild("serverMethods"))
local mochaStack = require(script:WaitForChild("mochaPrintStack"))
local mochaChatSignals = require(script:WaitForChild("chatSignals"))
local mochaListener = require(script:WaitForChild("mochaListeners"))
--

--Roblox Services
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
--

if script.Parent ~= game.ServerStorage then mochaStack.printErrorStack(500) end --Security measure, please follow it for your game's safety

local mochaChat = {}
---@class mochaChat
local metaMethod = {}
metaMethod.__index = metaMethod

--Misc Methods

function clearOldSystem()
    local robloxLuaChat = replicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")

    if robloxLuaChat then robloxLuaChat:Destroy() print("Destroyed RobloxLuaChat") end
end

function createCommunicator()
    local storage = Instance.new("Folder")
    storage.Name = "mochaChat"
    storage.Parent = replicatedStorage

    local clientToServer = Instance.new("RemoteEvent")
    clientToServer.Name = "clientToServer"
    clientToServer.Parent = storage

    local renderToClient = Instance.new("RemoteEvent")
    renderToClient.Name = "renderToClient"
    renderToClient.Parent = storage
    
    return storage
end
--

--Stores all the mochaListener instances here for collection purposes
function createListenerContainer()
    local storage = Instance.new("Configuration")
    storage.Parent = game:GetService("ServerStorage")
    storage.Name = "ListenerHolder"
end

createListenerContainer()
--mochaChat Constructor
---@return mochaChat
function mochaChat.new()
    ---@type mochaChat
    local self = {}
    self.Muted = {} --userIds that are muted
    self.Remote = createCommunicator()
    self.ActiveListeners = {}
    self = setmetatable(self, metaMethod)
    if not replicatedStorage:FindFirstChild("mochaClientEssentials") then
        script:FindFirstChild("mochaClientEssentials"):Clone().Parent = replicatedStorage
    end
    mochaChatSignals.init(self) --Launches the serversided part of the module
    return self
end
--

--Mutator/Setter Methods

---Mutes the player instance that is inputted into the method parameter, making them unable to talk
---[ServerSided only]
---@param playerToMute Instance | number
function metaMethod:Mute(playerToMute: Instance | number)
    if runService:IsClient() then mochaStack.printWarnStack(501) return end
    if playerToMute == nil then mochaStack.printWarnStack(502) return end

    if type(playerToMute) == "table" then mochaMethods.muteTable(playerToMute, self) return end
    mochaMethods.mutePlayer(playerToMute, self)
end

---Unmutes the player instance that is inputted into the method parameter, making them able to talk again
---[ServerSided only]
---@param playerToUnmute Instance | number
function metaMethod:UnMute(playerToUnmute: Instance | number)
    if runService:IsClient() then mochaStack.printWarnStack(501) return end
    if playerToUnmute == nil then mochaStack.printWarnStack(502) return end

    if type(playerToUnmute) == "table" then mochaMethods.unmuteTable(playerToUnmute, self) return end
    mochaMethods.unmutePlayer(playerToUnmute, self)
end

--

--Accessor/Getter Methods

---Returns All Currently Muted players
---@return table
function metaMethod:GetMutes()
    return self.Muted
end

---Returns ServerSided Methods
---@return table
function metaMethod:GetServer()
    self = {}
    return setmetatable(self, mochaChatSignals)
end

---Returns Listener Methods
---@return table
function metaMethod:GetListeners()
    return mochaListener
end

---Returns the current mochaRemotes in this chat object
---@return table
function metaMethod:GetRemote()
    return self.Remote
end

--

return mochaChat