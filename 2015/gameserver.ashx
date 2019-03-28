--rbxsig%jU4wk4faFow6jdVxDlu5J7Hil2iAz9z7Bvyh9QMViEfS1IqrhJRkxK3kmJMiL867c10hvZIhEGH2hzdclp11mYmPsF3cJMOrvYUQ5QC+GtTWxOTHrWQbppKMa0UE8/O876B3ZkjY9OOea4P8n/P4lpNNvo0BytsbemFXE5UrL+I=%
-- Start Game Script Arguments
local placeId, port, gameId, sleeptime, access, url, killID, deathID, timeout, machineAddress, gsmInterval, gsmUrl, maxPlayers, maxSlotsUpperLimit, maxSlotsLowerLimit, maxGameInstances, injectScriptAssetID, apiKey, libraryRegistrationScriptAssetID, pingTimesReportInterval, gameCode, universeId = ...


------------------- UTILITY FUNCTIONS --------------------------

local cdnSuccess = 0
local cdnFailure = 0

function reportCdn(blocking)
	pcall(function()
		local newCdnSuccess = settings().Diagnostics.CdnSuccessCount
		local newCdnFailure = settings().Diagnostics.CdnFailureCount
		local successDelta = newCdnSuccess - cdnSuccess
		local failureDelta = newCdnFailure - cdnFailure
		cdnSuccess = newCdnSuccess
		cdnFailure = newCdnFailure
		if successDelta > 0 or failureDelta > 0 then
			game:HttpGet("{17}/Game/Cdn.ashx?source=server&success=" .. successDelta .. "&failure=" .. failureDelta, blocking)
		end
	end)
end

function waitForChild(parent, childName)
	while true do
		local child = parent:findFirstChild(childName)
		if child then
			return child
		end
		parent.ChildAdded:wait()
	end
end

-- returns the player object that killed this humanoid
-- returns nil if the killer is no longer in the game
function getKillerOfHumanoidIfStillInGame(humanoid)

	-- check for kill tag on humanoid - may be more than one - todo: deal with this
	local tag = humanoid:findFirstChild("creator")

	-- find player with name on tag
	if tag then
		local killer = tag.Value
		if killer.Parent then -- killer still in game
			return killer
		end
	end

	return nil
end

-- send kill and death stats when a player dies
function onDied(victim, humanoid)
	local killer = getKillerOfHumanoidIfStillInGame(humanoid)
	local victorId = 0
	if killer then
		victorId = killer.userId
		game:HttpPost(url .. "/Game/Knockouts.ashx?UserID=" .. victorId .. "&" .. access, "")
	end
	game:HttpPost(url .. "/Game/Wipeouts.ashx?UserID=" .. victim.userId .. "&" .. access, "")
end

-----------------------------------END UTILITY FUNCTIONS -------------------------

-----------------------------------"CUSTOM" SHARED CODE----------------------------------

pcall(function() settings().Network.UseInstancePacketCache = true end)
pcall(function() settings().Network.UsePhysicsPacketCache = true end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)


settings().Network.PhysicsSend = Enum.PhysicsSendMethod.TopNErrors
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
pcall(function() settings().Diagnostics:LegacyScriptMode() end)

-----------------------------------START GAME SHARED SCRIPT------------------------------

local assetId = placeId -- might be able to remove this now

local scriptContext = game:GetService('ScriptContext')
pcall(function() scriptContext:AddStarterScript(libraryRegistrationScriptAssetID) end)
scriptContext.ScriptsDisabled = true

game:SetPlaceID(assetId, false)
pcall(function () if universeId ~= nil then game:SetUniverseId(universeId) end end)
game:GetService("ChangeHistoryService"):SetEnabled(false)

-- establish this peer as the Server
local ns = game:GetService("NetworkServer")

local badgeUrlFlagExists, badgeUrlFlagValue = pcall(function () return settings():GetFFlag("NewBadgeServiceUrlEnabled") end)
local newBadgeUrlEnabled = badgeUrlFlagExists and badgeUrlFlagValue
if url~=nil then
	local apiProxyUrl = string.gsub(url, "http://www", "https://api")    -- hack - passing domain (ie "sitetest1.robloxlabs.com") and appending "https://api." to it would be better

	pcall(function() game:GetService("Players"):SetAbuseReportUrl(url .. "/AbuseReport/InGameChatHandler.ashx") end)
	pcall(function() game:GetService("ScriptInformationProvider"):SetAssetUrl(url .. "/Asset/") end)
	pcall(function() game:GetService("ContentProvider"):SetBaseUrl(url .. "/") end)
	pcall(function() game:GetService("Players"):SetChatFilterUrl(url .. "/Game/ChatFilter.ashx") end)
	
	if gameCode then
		game:SetVIPServerId(tostring(gameCode))
	end

	game:GetService("BadgeService"):SetPlaceId(placeId)

	if newBadgeUrlEnabled then
		game:GetService("BadgeService"):SetAwardBadgeUrl(apiProxyUrl .. "/assets/award-badge?userId=%d&badgeId=%d&placeId=%d")
	end

	if access~=nil then
		if not newBadgeUrlEnabled then
			game:GetService("BadgeService"):SetAwardBadgeUrl(url .. "/Game/Badge/AwardBadge.ashx?UserID=%d&BadgeID=%d&PlaceID=%d&" .. access)
		end

		game:GetService("BadgeService"):SetHasBadgeUrl(url .. "/Game/Badge/HasBadge.ashx?UserID=%d&BadgeID=%d&" .. access)
		game:GetService("BadgeService"):SetIsBadgeDisabledUrl(url .. "/Game/Badge/IsBadgeDisabled.ashx?BadgeID=%d&PlaceID=%d&" .. access)

		game:GetService("FriendService"):SetMakeFriendUrl(url .. "/Game/CreateFriend?firstUserId=%d&secondUserId=%d")
		game:GetService("FriendService"):SetBreakFriendUrl(url .. "/Game/BreakFriend?firstUserId=%d&secondUserId=%d")
		game:GetService("FriendService"):SetGetFriendsUrl(url .. "/Game/AreFriends?userId=%d")
	end
	game:GetService("BadgeService"):SetIsBadgeLegalUrl("")
	game:GetService("InsertService"):SetBaseSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
	game:GetService("InsertService"):SetUserSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
	game:GetService("InsertService"):SetCollectionUrl(url .. "/Game/Tools/InsertAsset.ashx?sid=%d")
	game:GetService("InsertService"):SetAssetUrl(url .. "/Asset/?id=%d")
	game:GetService("InsertService"):SetAssetVersionUrl(url .. "/Asset/?assetversionid=%d")
	
	pcall(function() loadfile(url .. "/Game/LoadPlaceInfo.ashx?PlaceId=" .. placeId)() end)
	
	pcall(function() 
				if access then
					loadfile(url .. "/Game/PlaceSpecificScript.ashx?PlaceId=" .. placeId .. "&" .. access)()
				end
			end)
end

pcall(function() game:GetService("NetworkServer"):SetIsPlayerAuthenticationRequired(true) end)
settings().Diagnostics.LuaRamLimit = 0



if placeId~=nil and killID~=nil and deathID~=nil and url~=nil then
	-- listen for the death of a Player
	function createDeathMonitor(player)
		-- we don't need to clean up old monitors or connections since the Character will be destroyed soon
		if player.Character then
			local humanoid = waitForChild(player.Character, "Humanoid")
			humanoid.Died:connect(
				function ()
					onDied(player, humanoid)
				end
			)
		end
	end

	-- listen to all Players' Characters
	game:GetService("Players").ChildAdded:connect(
		function (player)
			createDeathMonitor(player)
			player.Changed:connect(
				function (property)
					if property=="Character" then
						createDeathMonitor(player)
					end
				end
			)
		end
	)
end

game:GetService("Players").PlayerAdded:connect(function(player)
	print("Player " .. player.userId .. " added")
	
	if url and access and placeId and player and player.userId then
		game:HttpGet(url .. "/Game/ClientPresence.ashx?action=connect&" .. access .. "&PlaceID=" .. placeId .. "&UserID=" .. player.userId)
		game:HttpPost(url .. "/Game/PlaceVisit.ashx?UserID=" .. player.userId .. "&AssociatedPlaceID=" .. placeId .. "&" .. access, "")
	end
end)


game:GetService("Players").PlayerRemoving:connect(function(player)
	print("Player " .. player.userId .. " leaving")	

	if url and access and placeId and player and player.userId then
		game:HttpGet(url .. "/Game/ClientPresence.ashx?action=disconnect&" .. access .. "&PlaceID=" .. placeId .. "&UserID=" .. player.userId)
	end
end)

local onlyCallGameLoadWhenInRccWithAccessKey = newBadgeUrlEnabled
if placeId~=nil and url~=nil and ((not onlyCallGameLoadWhenInRccWithAccessKey) or access ~= nil) then
	-- yield so that file load happens in the heartbeat thread
	wait()
	
	-- load the game
	game:Load(url .. "/asset/?id=" .. placeId)
end

-- Now start the connection
ns:Start(port, sleeptime) 

if timeout then
	scriptContext:SetTimeout(timeout)
end
scriptContext.ScriptsDisabled = false




-- StartGame --

if injectScriptAssetID and (injectScriptAssetID < 0) then
	pcall(function() Game:LoadGame(injectScriptAssetID * -1) end)
else
	pcall(function() Game:GetService("ScriptContext"):AddStarterScript(injectScriptAssetID) end)
end

Game:GetService("RunService"):Run()

