local config = {
	-- !! Remember to reset all players' data whenever you update the tycoon by
	-- adding or removing purchasable objects. If you don't, things may break.
	--`i Hope u understood, tell me what to do, take ur time and make it happen:
	-- ^ This can be done by simply changing the "dataStoreName"
	-- setting to something you haven't used before.
	
	
	-- * Documentation for each setting is at the bottom.
	
	
	-- // Currency Settings \\ --
	
	--[[ Note: The order in which the currencies appear in the table below
	is the same order they will appear on the leaderboard. Top to bottom in
	the table is left to right on the leaderboard. ]]
	
	Currencies = {
		{
			Name = "Cash",
			Color = Color3.fromRGB(0, 255, 0),
			StartingValue = 0,
			DeductOnPurchase = true,
			DisplayOnLeaderboard = true,
		},
		{
			Name = "Gems",
			Color = Color3.fromRGB(82, 124, 174),
			StartingValue = 0,
			DeductOnPurchase = true,
			DisplayOnLeaderboard = true,
		},
	},
	
	-- // Tycoon Settings \\ --
	AutoCollect = false,
	AutoAssignTycoons = true,
	SimulateDropsOnClient = true,
	PurchaseCooldown = 0.25,
	DropLifeTime = 60,	
	StealingEnabled = false,
	StealPercentage = 50,
	StealCooldownMinutes = 5,
	
	-- // Data Settings	\\ --
	SaveTycoon = true,
	SaveLeaderstats = true,
	LoadLeaderstatsOnJoin = true,
	AutoSaveIntervalMinutes = 0.01,
	DataStoreName = "DataStoreName20",
	TycoonDataKey = "-tycoon20",
	LeaderstatsDataKey = "-currency",
	
	-- // Rebirth Settings \\ --
	RebirthsEnabled = true,
	RebirthsName = "Rebirths",
	RebirthMultiplier = 1,
	RebirthCompletionPercentage = 100,
	HideRebirthButtons = false,
	ReloadCharacterOnRebirth = false,
	DisplayRebirthsOnLeaderboard = true,
	
	RebirthLimit = 3, -- hard cap at 3 rebirths

	-- Optional global fallback requirements (used if a tier entry is missing)
	RebirthRequiredPets = {"Dog"},
	RebirthRequiredCurrency = { Currency = 5000 },

	-- Per-next-rebirth requirements (recommended)
	RebirthRequirementsByTier = {
		[1] = { -- requirement for rebirth #1
			RequiredPets = {"PetTemplate"},
			RequiredCurrency = { Currency = 2 },
		},
		[2] = { -- requirement for rebirth #2
			RequiredPets = {"cameleon", "PetTemplate"},
			RequiredCurrency = { Currency = 2, Currency2 = 10 },
		},
		[3] = { -- requirement for rebirth #3
			RequiredPets = {"cameleon", "mamuta", "monkey"},
			RequiredCurrency = { Currency = 22 },
		},
	},
	
	-- // Sound Settings \\ --
	SoundsEnabled = true,
	SoundBehavior = "Client",
	
	-- // Animation Settings \\ --
	AnimationsEnabled = true,
	GlobalAnimations = true,
	AnimationRangeStuds = 300,
	
	ObjectPurchaseAnimationTime = 0.75,
	ObjectRemoveAnimationTime = 0.25,
	ObjectPurchaseAnimationStyle = "FallFadeInStaggered",
	ObjectRemoveAnimationStyle = "FallFadeOutStaggered",
	
	ButtonAppearAnimationTime = 0.25,
	ButtonVanishAnimationTime = 0.25,
	ButtonAppearAnimationStyle = "Grow",
	ButtonVanishAnimationStyle = "Shrink",
	
	-- // Team Settings \\ --
	TeamsEnabled = false,
	NeutralTeamName = "No Tycoon",
	NeutralTeamColor = BrickColor.new("White")
	
	
	-- // Settings Documentation \\ --
	--[[
		CURRENCY SETTINGS:
	
		Currencies: A table containing all of the currencies in your tycoon. Each currency is a table with the following attributes:
			- Name (string): The name of the currency.
			- Color (Color3): The color of the currency, which will be displayed on the CurrencyCollector's display.
			- StartingValue (number): The amount of currency that players start with when they first join the game.
			- DeductOnPurchase (boolean): Whether or not this currency should be deducted from a player's balance when they purchase something.
			- DisplayOnLeaderboard (boolean): Whether or not this currency is displayed on the leaderboard.
		
		
		TYCOON SETTINGS:
		
		AutoCollect: Whether or not currency should automatically be added to the player's balance when drops are collected.
			* If disabled, players must manually collect currency by interacting with the Currency Collector in your tycoon.
			* Set this to a game pass' ID enable auto collect for only players who own the game pass.
		
		AutoAssignTycoons: Whether or not players will be automatically assigned a tycoon when they join the game.
		
		SimulateDropsOnClient: Whether or not physics calculations for drops should be performed by the client instead of on the server.
			* This can greatly improve performance but may make it easier for exploiters to manipulate drops if you don't have proper security measures in place.
		
		PurchaseCooldown: The cooldown time in seconds for purchasing objects.
			* This can help prevent players from making unwanted purchases if buttons are very close together.
			* Set to 0 for no cooldown.
			
		DropLifeTime: The maximum amount of time (in seconds) a drop is allowed to exist in the game before being removed.
			* This can help remove any drops that become stuck or fall off a conveyor.
			* Set to 0 for no life time limit. (Not recommended)
			
		StealingEnabled: Whether or not players can steal currency from other players' currency collectors.
		
		StealPercentage: The percentage of currency a player will receive when stealing from another player.
		
		StealCooldownMinutes: The time in minutes that must pass after a player has been stolen from before they can be stolen from again.
		
		
		DATA SETTINGS
		
		SaveTycoon: Whether or not the tycoon saves.
		
		SaveLeaderstats: Whether or not players' leaderstats (currency and rebirths) save.
		
		LoadLeaderstatsOnJoin: Whether leaderstats should be loaded for players when the join the game or claim a tycoon.
		
		AutoSaveIntervalMinutes: The amount of time in minutes between automatic data saves.
			* Set to 0 to disable automatic saving.
		
		DataStoreName: The name of the datastore that all data is saved to.
			* Changing this will reset all players' tycoon and leaderstats data.
		
		TycoonDataKey: The key that all tycoon data is saved to in the datastore.
			* Changing this will reset all players' tycoon data. (Not recommended)
		
		LeaderstatsDataKey: The key that all leaderstats (currency + rebirths) data is saved to in the datastore.
			* Changing this will reset all players' leaderstats data. (Not recommended)
		
		
		REBIRTH SETTINGS
		
		RebirthsEnabled: Whether rebirths are enabled in the tycoon.
			* Rebirths allow players who have reached a certain level of progress to reset their progress and earn rewards based on how many times they've rebirthed before.
		
		RebirthsName: The name that rebirths will be called the leaderboard.
			* The rebirth attribute on buttons must match this to function correctly.
		
		RebirthMultiplier: The multiplier that is applied to the player's collected currency for each rebirth.
			* When the player collects currency, it will be multiplied by one plus this value times their amount of rebirths.
				* The formula is [currency * (1 + (rebirthsMultiplier * rebirths))]
			* Basically, this value is added to the multiplier for every rebirth.
		
		RebirthCompletionPercentage: The percentage of the tycoon that must be completed before a player can rebirth.
		
		RebirthLimit: The maximum number of times a player can rebirth.
			* Set to 0 for no limit.
		
		HideRebirthButtons: Whether buttons that require rebirths should be hidden from players who haven't yet rebirthed enough times to purchase them.
	
		ReloadCharacterOnRebirth: Whether the player's character should be reloaded when they rebirth.
	
		DisplayRebirthsOnLeaderboard: Whether rebirths should be displayed on the leaderboard.
		
		SOUND SETTINGS:
	
		SoundsEnabled: If set to true, sounds will be played when a player performs certain actions in their tycoon.
			* You can find and edit sounds for each action in the SoundsFolder.
				* To disable a specific sound, simply remove it or set its Volume to 0.
		
		SoundBehavior: Either "Client" or "Server".
			* If set to "Client", sounds will only play for the client (player) that activates them.
			* If set to "Server", sounds will emit from their source in the workspace and can be heard by all players in range.
				* The range at which a sound can be heard is determined by the RollOffMaxDistance property of that sound in the SoundsFolder.
		
		
		ANIMATION SETTINGS:
		
		AnimationsEnabled: Whether or not object animations are enabled.
		
		GlobalAnimations: If set to true, all clients (players) can see animations if they are in range.
			* If set to false, animations will only be visible to the tycoon's owner if they are in range.
		
		AnimationRangeStuds: The maximum distance in studs a player can be from an object for an animation to play.
		
		
		PurchaseAnimationTime: The time in seconds that it takes for the animation to play on an object when it is purchased.
		
		RemoveAnimationTime: The time in seconds that it takes for the animation to play on an object when it is removed.
		
		PurchaseAnimationStyle: The style of animation that plays when an object is purchased.
			* There are 6 purchase animations that can be used:
			- "FadeIn"
			- "Grow"
			- "FallFadeIn"
			- "AscendFadeIn"
			- "FallFadeInStaggered"
			- "AscendFadeInStaggered"
			* You can add your own custom animation functions to the ObjectAnimationsModule.
		
		RemoveAnimationStyle: The style of animation that plays when an object is removed.
			* There are 6 remove animations that can be used:
			- "FadeOut"
			- "Shrink"
			- "AscendFadeOut"
			- "FallFadeOut"
			- "AscendFadeOutStaggered"
			- "FallFadeOutStaggered"
			* You can add your own custom animation functions to the ObjectAnimationsModule.
		
		ButtonAppearAnimationTime: The time (in seconds) it takes for the animation to play on a button when it appears.
		
		ButtonVanishAnimationTime: The time (in seconds) it takes for the animation to play on a button when it vanishes.
		
		ButtonAppearAnimationStyle: The style of animation that plays when a button appears.
			* These animation styles are the same as the purchase animation styles.
		
		ButtonVanishAnimationStyle: The style of animation that plays when a button vanishes.
			* These animation styles are the same as the remove animation styles.
		
		
		TEAM SETTINGS:
		
		TeamsEnabled: Whether teams should be created for each tycoon
		
		NeutralTeamName: The name of the team that players are assigned when they have no tycoon.
			* This setting has no effect if AutoAssignTycoons is true.
			
		NeutralTeamColor: The color of the team that players are assigned when they have no tycoon.
			* This setting has no effect if AutoAssignTycoons is true.
	]]
}

return config
