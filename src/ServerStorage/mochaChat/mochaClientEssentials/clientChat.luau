--Mocha Modules

local mochaDependencies = script.Parent:WaitForChild("mochaDependencies")
local roact = require(mochaDependencies.Roact[".source"])
local topBarPlus = require(mochaDependencies:WaitForChild("TopBarPlus"))
local clientPrintStack = require(script.Parent:WaitForChild("mochaClientPrintStack"))
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

--Defaults incase the instance is nil

local defaultChatInfo = {
    pcUiScale = UDim2.new(0.3,0,0.308,0);
    phoneUiScale = UDim2.new(0.5,0,0.585,0);
    tabletUiScale = UDim2.new(0.4,0,0.333,0);

    ["ChatBackground"] = roact.createElement("Frame", {

    }),
    ["Chat"] = roact.createElement("ScrollingFrame", {

    }),

    ["ChatBoxBackground"] = roact.createElement("Frame", {
        Size = UDim2.new(1,0,0,42);
        Position = UDim2.new(0,0,1,-42)
    }),
    ["ChatBox"] = roact.createElement("TextBox", {

    })
    
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
methods.Refs = {}
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

function isValidUiData(uiData)

    for uiInstance, _ in defaultChatInfo do
        if uiData[tostring(uiInstance)] == nil then clientPrintStack.printWarnStack(600, uiInstance) return false end
    end

    return true
end

---Destroys the current Chat UI
function methods:DestroyUI()
    self.uiInstanceAlive = false
    if self.currentActiveUI == nil then clientPrintStack.printWarnStack(601) return end
    roact.unmount(self.currentActiveUI)
end

---Creates a new Chat UI
---@param uiData table
function methods:CreateUI(uiData)
    local deviceType = checkChatUI(self)
    print(deviceMode:getName(deviceType))
    if deviceType == deviceMode.CONSOLE then clientPrintStack.printErrorStack(600) end

    if not isValidUiData(uiData) then uiData = defaultChatInfo end
    
end
--

--

--Getter/Setter methods

function methods:SetUserColorIndex(colorModule)
    if colorModule == nil or not colorModule:IsA("Module") then warn("Provided instance is not a module") return end
    self.userColorIndex = colorModule
end

function methods:createUiTemplate()
    local this = {}
    this.__index = this
    return setmetatable(defaultChatInfo, this)
end

function methods:GetUserColorIndex()
    return self.userColorIndex
end

--

return mochaChatClient