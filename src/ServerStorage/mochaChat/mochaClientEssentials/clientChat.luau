--Mocha Modules

local mochaDependencies = script.Parent:WaitForChild("mochaDependencies")
local roact = require(mochaDependencies.Roact)
local topBarPlus = require(mochaDependencies:WaitForChild("TopBarPlus"))

--

--Roblox Services

local guiService = game:GetService("GuiService")
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

function deviceMode:getName(enumValue)
    for key, v in deviceMode do
        if type(v) ~= "number" then continue end
        if v == enumValue then return tostring(key) end
    end
    return "nil"
end

function deviceMode:GetEnumItems()
    return self
end
--

--

--mochaChat's clientSided Class, that handles anything clientsided
---@class mochaChatClient
local methods = {}
methods.__index = methods
methods.uiInstanceAlive = true
methods.currentActiveUI = nil
methods.userColorIndex = nil
methods.deviceMode = nil
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

--static methods

function mochaChatClient.Roact()
    return roact
end
--

--methods

---@param clientChatInstance mochaChatClient
---@return any
function checkChatUI(clientChatInstance)
    local isConsole = guiService:IsTenFootInterface()
    local screenWidth = workspace.CurrentCamera.ViewportSize.X
    local phoneWidth, tabletWidth = 640, 1024

    if isConsole then return deviceMode.CONSOLE end
    if screenWidth <= phoneWidth then return deviceMode.PHONE end
    if screenWidth <= tabletWidth then return deviceMode.TABLET end
    return deviceMode.PC
end

---Destroys the current Chat UI
function methods:DestroyUI()
    self.uiInstanceAlive = false
    if self.currentActiveUI == nil then warn("No UI currently available, cannot destroy") return end
    roact.unmount(self.currentActiveUI)
end

---Creates a new Chat UI
---@param uiData table
function methods:CreateUI(uiData)
    local deviceType = checkChatUI(self)
    print(deviceMode:getName(deviceType))
    if deviceType == deviceMode.CONSOLE then error("User is on console, Terminating client UI", 0) end
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