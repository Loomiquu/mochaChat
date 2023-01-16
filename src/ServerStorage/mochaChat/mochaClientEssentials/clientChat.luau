--Mocha Modules

local mochaDependencies = script.Parent:WaitForChild("mochaDependencies")
local roact = require(mochaDependencies.Roact[".source"])
local topBarPlus = require(mochaDependencies:WaitForChild("TopBarPlus"))

--

--Roblox Services

local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

--

--Variables

local serverSignals = replicatedStorage:WaitForChild("mochaChat")
local localPlayer = playerService.LocalPlayer

--

local mochaChatClient = {}

--Custom Enums

---@type Enum
--The Device Type used to determine the size of the chatUI
local deviceMode = {
    PC = 1;
    PHONE = 2;
    TABLET = 3;
    CONSOLE = 4; --This is only used to disable mochaChat on xbox
}

--

--

--mochaChat's clientSided Class, that handles anything clientsided
---@class mochaChatClient
local methods = {}
methods.__index = methods
methods.uiInstanceAlive = true
methods.currentActiveUI = nil
methods.userColorIndex = nil
methods.maxLimit = 50

--

---Constructor Method for mochaChatClient
---@return mochaChatClient
function mochaChatClient.new()
    local self = {}
    ---@type mochaChatClient
    self = setmetatable(self, methods)
    return self
end

--methods

---Destroys the current Chat UI
function methods:DestroyUI()
    self.uiInstanceAlive = false
    if self.currentActiveUI == nil then warn("No UI currently available, cannot destroy") return end
    roact.unmount(self.currentActiveUI)
end

---Creates a new Chat UI
---@param uiParams table
function methods:CreateUI(uiParams)
    
end
--

--

--Getter/Setter methods

function methods:SetUserColorIndex(colorModule)
    if colorModule == nil or not colorModule:IsA("Module") then warn("Provided instance is not a module") return end
    self.userColorIndex = colorModule
end

function methods:setMessageLimit(x)
    if x == nil or x <= 0 then x = 1 end
    methods.maxLimit = x
end

function methods:GetmessageLimit()
    return self.maxLimit
end

function methods:GetUserColorIndex()
    return self.userColorIndex
end

--

return mochaChatClient