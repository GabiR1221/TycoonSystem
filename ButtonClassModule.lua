---ButtonScriptModule
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local BadgeService = game:GetService("BadgeService")
local Workspace = game:GetService("Workspace")

local CurrencyBridge = require(Workspace:FindFirstChild("Tycoon"):FindFirstChild("CurrencyBridge"))
local configModule = require(script.Parent.Parent.Parent.Settings)

local Button = {}
Button.__index = Button

function Button.new(object, tycoon)
	local self = setmetatable({}, Button)
	self.Instance = object
	self.Tycoon = tycoon
	return self
end

-- Helper: split "a, b, c" into table {"a","b","c"}
local function StringToTable(str : string)
	return str and string.split(string.gsub(str, " ", ""), ",")
end

-- Convert a list of object names to object Instances (search both Purchases and PurchasedObjects)
function Button:StringListToObjects(list : {string})
	if not list then return {} end
	local objects = {}
	for _, name in ipairs(list) do
		local object = self.Tycoon.Purchases:FindFirstChild(name) or self.Tycoon.PurchasedObjects:FindFirstChild(name)
		if not object and name ~= "" then
			warn("Object '"..name.."' not found in tycoon '"..self.Tycoon.Name.."' for button '"..self.Instance.Name.."'")
			continue
		end
		table.insert(objects, object)
	end
	return objects
end

function Button:Initialize()
	-- Convert button attributes to tables of objects
	self.PurchaseDependencies = self:StringListToObjects(StringToTable(self.Instance:GetAttribute("PurchaseDependencies")))
	self.RemoveDependencies = self:StringListToObjects(StringToTable(self.Instance:GetAttribute("RemoveDependencies")))
	self.PurchaseObjects = self:StringListToObjects(StringToTable(self.Instance:GetAttribute("PurchaseObjects")))
	self.RemoveObjects = self:StringListToObjects(StringToTable(self.Instance:GetAttribute("RemoveObjects")))

	self.PurchaseDependencies = #self.PurchaseDependencies > 0 and self.PurchaseDependencies or nil
	self.RemoveDependencies = #self.RemoveDependencies > 0 and self.RemoveDependencies or nil
	self.PurchaseObjects = #self.PurchaseObjects > 0 and self.PurchaseObjects or nil
	self.RemoveObjects = #self.RemoveObjects > 0 and self.RemoveObjects or nil

	-- Validate
	if not self.PurchaseObjects and not self.RemoveObjects then
		warn("Button '"..self.Instance.Name.."' requires at least one valid PurchaseObject or RemoveObject; removed button")
		self:Destroy()
		return false
	end

	-- Hide the button if it has dependencies (they will be restored later)
	if self.PurchaseDependencies or self.RemoveDependencies then
		self.Instance.Parent = nil
	end
end

-- Returns true (and deducts currency) if purchase allowed; nil otherwise.
function Button:AttemptPurchase()
	-- owner player object
	local owner = Players:GetPlayerByUserId(self.Tycoon:GetAttribute("OwnerId"))
	if not owner then return end

	-- server-side saved folder (may be nil if not created yet)
	local ownerFolder = ServerStorage:FindFirstChild("PlayerData") and ServerStorage.PlayerData:FindFirstChild(tostring(owner.UserId))

	-- 1) Rebirth gating (checked first). If a button has a rebirth requirement and the player
	-- hasn't reached it, deny purchase. If server folder missing, treat as 0 rebirths.
	if configModule.RebirthsEnabled == true and self.Instance:GetAttribute(configModule.RebirthsName) then
		local required = tonumber(self.Instance:GetAttribute(configModule.RebirthsName)) or 0
		local rebirths = ownerFolder and ownerFolder:GetAttribute(configModule.RebirthsName) or 0
		if rebirths < required then
			-- not enough rebirths
			return
		end
	end

	-- 2) Game pass check
	local gamePassId = self.Instance:GetAttribute("GamePassId")
	if gamePassId and not MarketplaceService:UserOwnsGamePassAsync(owner.UserId, gamePassId) then
		MarketplaceService:PromptGamePassPurchase(owner, gamePassId)
		return
	end

	-- 3) Group check
	local groupId = self.Instance:GetAttribute("GroupId")
	if groupId and not owner:IsInGroup(groupId) then return end

	-- 4) Badge check
	local badgeId = self.Instance:GetAttribute("BadgeId")
	if badgeId and not BadgeService:UserHasBadgeAsync(owner.UserId, badgeId) then return end

	-- 5) Currency check & deduction:
	--    Look for any simulator currency attribute on the button (Currency, Currency2, etc).
	--    If present, ensure player's simulator balance is sufficient and record deduction.
	local currenciesToDeduct = {}
	local currencyNames = CurrencyBridge.GetCurrencyNames()
	for _, currencyName in ipairs(currencyNames) do
		local price = self.Instance:GetAttribute(currencyName)
		if not price or type(price) ~= "number" then continue end

		-- get player's simulator balance for that currency (via CurrencyBridge)
		local current = CurrencyBridge.Get(owner, currencyName)
		if current < price then
			-- insufficient funds
			return
		end

		-- record deduction
		currenciesToDeduct[currencyName] = price
	end

	-- Deduct recorded currencies (do this after all checks pass)
	for currencyName, amount in pairs(currenciesToDeduct) do
		CurrencyBridge.Change(owner, currencyName, -amount)
	end

	-- All checks passed
	return true
end

function Button:Destroy()
	if self.Instance then self.Instance:Destroy() end
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Button
