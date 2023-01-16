local NAME_COLORS =
	{
		Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
		Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
		Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
		BrickColor.new("Bright violet").Color,
		BrickColor.new("Bright orange").Color,
		BrickColor.new("Bright yellow").Color,
		BrickColor.new("Light reddish violet").Color,
		BrickColor.new("Brick yellow").Color,
	}

local robloxChatColor = {}

function GetNameValue(pName) --Roblox's chat color algorithm
		local value = 0
		for index = 1, #pName do
			local cValue = string.byte(string.sub(pName, index, index))
			local reverseIndex = #pName - index + 1
			if #pName%2 == 1 then
				reverseIndex = reverseIndex - 1
			end
			if reverseIndex%4 >= 2 then
				cValue = -cValue
			end
			value = value + cValue
		end
		return value
	end

colorOffset = 0
function ComputeNameColor(nameValue)
	return NAME_COLORS[((nameValue + robloxChatColor.colorOffset) % #NAME_COLORS) + 1]
end

---Returns a Color3 using roblox's color algorithm
---@param player Player
---@return Color3
function robloxChatColor:GenerateColor(player)
    local playerName = player.Name
    playerName = GetNameValue(playerName)
    return ComputeNameColor(playerName)
end

---Sets the Color Offset of the robloxChatColor module
---@param newNumber number
function robloxChatColor:SetColorOffset(newNumber)
    newNumber = math.floor(newNumber)
    colorOffset = newNumber
end

return robloxChatColor