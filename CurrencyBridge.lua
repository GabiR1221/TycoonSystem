-- CurrencyBridge (ModuleScript) - in the Tycoon folder
local ServerStorage = game:GetService("ServerStorage")

local CurrencyBridge = {}

-- List the simulator currency names the tycoon will use.
-- If you later add more simulator currencies, add them here.
function CurrencyBridge.GetCurrencyNames()
	return { "Currency", "Currency2" }
end

-- Returns the Value object in player.Data.PlayerData for currencyName if present,
-- otherwise nil (caller can fallback to ServerStorage attributes).
function CurrencyBridge.FindPlayerValueObject(player, currencyName)
	if not player or not currencyName then return nil end
	local dataFolder = player:FindFirstChild("Data")
	if dataFolder then
		local playerData = dataFolder:FindFirstChild("PlayerData")
		if playerData then
			local val = playerData:FindFirstChild(currencyName)
			if val and (val:IsA("IntValue") or val:IsA("NumberValue")) then
				return val
			end
		end
	end
	-- fallback: server-side stored attributes (can't return an Attribute as Value)
	local serverFolder = ServerStorage:FindFirstChild("PlayerData")
	if serverFolder then
		local folder = serverFolder:FindFirstChild(tostring(player.UserId))
		if folder then
			return nil
		end
	end
	return nil
end

function CurrencyBridge.Get(player, currencyName)
	currencyName = tostring(currencyName or "Currency")
	local valObj = CurrencyBridge.FindPlayerValueObject(player, currencyName)
	if valObj then
		return tonumber(valObj.Value) or 0
	end
	-- fallback to ServerStorage attributes
	local serverFolder = ServerStorage:FindFirstChild("PlayerData")
	if serverFolder then
		local folder = serverFolder:FindFirstChild(tostring(player.UserId))
		if folder then
			return tonumber(folder:GetAttribute(currencyName)) or 0
		end
	end
	return 0
end

function CurrencyBridge.Set(player, currencyName, newValue)
	currencyName = tostring(currencyName or "Currency")
	local valObj = CurrencyBridge.FindPlayerValueObject(player, currencyName)
	if valObj then
		valObj.Value = tonumber(newValue) or 0
		return true
	end
	local serverFolder = ServerStorage:FindFirstChild("PlayerData")
	if serverFolder then
		local folder = serverFolder:FindFirstChild(tostring(player.UserId))
		if folder then
			folder:SetAttribute(currencyName, tonumber(newValue) or 0)
			return true
		end
	end
	return false
end

-- delta can be positive (add) or negative (remove)
-- also attempts to update Total<CurrencyName> if available (Value object or attribute)
function CurrencyBridge.Change(player, currencyName, delta)
	currencyName = tostring(currencyName or "Currency")
	delta = tonumber(delta or 0)
	local valObj = CurrencyBridge.FindPlayerValueObject(player, currencyName)
	if valObj then
		valObj.Value = (tonumber(valObj.Value) or 0) + delta
		-- if delta > 0, increment TotalCurrencyName if present
		if delta > 0 then
			local totalName = "Total" .. currencyName
			local totalObj = CurrencyBridge.FindPlayerValueObject(player, totalName)
			if totalObj then
				totalObj.Value = (tonumber(totalObj.Value) or 0) + delta
			else
				local serverFolder = ServerStorage:FindFirstChild("PlayerData")
				if serverFolder then
					local folder = serverFolder:FindFirstChild(tostring(player.UserId))
					if folder then
						local curTotal = tonumber(folder:GetAttribute(totalName)) or 0
						folder:SetAttribute(totalName, curTotal + delta)
					end
				end
			end
		end
		return true
	end

	-- fallback to attributes in ServerStorage
	local serverFolder = ServerStorage:FindFirstChild("PlayerData")
	if serverFolder then
		local folder = serverFolder:FindFirstChild(tostring(player.UserId))
		if folder then
			local cur = tonumber(folder:GetAttribute(currencyName)) or 0
			folder:SetAttribute(currencyName, cur + delta)
			if delta > 0 then
				local totalName = "Total" .. currencyName
				local curTotal = tonumber(folder:GetAttribute(totalName)) or 0
				folder:SetAttribute(totalName, curTotal + delta)
			end
			return true
		end
	end

	return false
end

return CurrencyBridge
