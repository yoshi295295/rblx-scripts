--rbxsig%PSStFWcJcQoaFTvxVHpq8laYAPVeTsOW/y0JIZdCeV22ItRJ/Woz7uW7cJQ/qQVAbAOdUb4TiRjDc+FU1lF/YMsuMJi+Idseu2kXerw32aIXtGMKVoCM1jVU4byDcc4RchdzcEyXta4z6PvzRktv4x7ZgOAFzr76DWMJNv/2EcY=%
-- Start Game Script Arguments
local placeId, port, gameId, sleeptime, access, deprecated, timeout, machineAddress, gsmInterval, baseUrl, maxPlayers, maxGameInstances, injectScriptAssetID, apiKey, libraryRegistrationScriptAssetID, deprecated_pingTimesReportInterval, gameCode, universeId, preferredPlayerCapacity, matchmakingContextId, placeVisitAccessKey, assetGameSubdomain, protocol = ...

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
local url = nil
local assetGameUrl = nil
if baseUrl~=nil and protocol ~= nil then
	url = protocol .. "www." .. baseUrl --baseUrl is actually the domain, no leading .
	assetGameUrl = protocol .. assetGameSubdomain .. "." .. baseUrl
end

local scriptContext = game:GetService('ScriptContext')
pcall(function() scriptContext:AddStarterScript(libraryRegistrationScriptAssetID) end)
scriptContext.ScriptsDisabled = true

game:SetPlaceID(assetId, false)
pcall(function () if universeId ~= nil then game:SetUniverseId(universeId) end end)
game:GetService("ChangeHistoryService"):SetEnabled(false)

-- establish this peer as the Server
local ns = game:GetService("NetworkServer")
-- Detect cloud edit mode by checking for the dedicated cloud edit matchmaking context
local isCloudEdit = matchmakingContextId == 3
if isCloudEdit then
	print("Configuring as cloud edit server!")
	game:SetServerSaveUrl(url .. "/ide/publish/UploadFromCloudEdit")	
	ns:ConfigureAsCloudEditServer()
end

local badgeUrlFlagExists, badgeUrlFlagValue = pcall(function () return settings():GetFFlag("NewBadgeServiceUrlEnabled") end)
local newBadgeUrlEnabled = badgeUrlFlagExists and badgeUrlFlagValue
if url~=nil then
	local apiProxyUrl = "https://api." .. baseUrl -- baseUrl is really the domain

	pcall(function() game:GetService("Players"):SetAbuseReportUrl(url .. "/AbuseReport/InGameChatHandler.ashx") end)
	pcall(function() game:GetService("ScriptInformationProvider"):SetAssetUrl(assetGameUrl .. "/Asset/") end)
	pcall(function() game:GetService("ContentProvider"):SetBaseUrl(url .. "/") end)
	pcall(function() game:GetService("Players"):SetChatFilterUrl(assetGameUrl .. "/Game/ChatFilter.ashx") end)
	
	if gameCode then
		game:SetVIPServerId(tostring(gameCode))
	end

	game:GetService("BadgeService"):SetPlaceId(placeId)

	if newBadgeUrlEnabled then
		game:GetService("BadgeService"):SetAwardBadgeUrl(apiProxyUrl .. "/assets/award-badge?userId=%d&badgeId=%d&placeId=%d")
	end

	if access ~= nil then
		if not newBadgeUrlEnabled then
			game:GetService("BadgeService"):SetAwardBadgeUrl(assetGameUrl .. "/Game/Badge/AwardBadge.ashx?UserID=%d&BadgeID=%d&PlaceID=%d")
		end

		game:GetService("BadgeService"):SetHasBadgeUrl(assetGameUrl .. "/Game/Badge/HasBadge.ashx?UserID=%d&BadgeID=%d")
		game:GetService("BadgeService"):SetIsBadgeDisabledUrl(assetGameUrl .. "/Game/Badge/IsBadgeDisabled.ashx?BadgeID=%d&PlaceID=%d")

		game:GetService("FriendService"):SetMakeFriendUrl(assetGameUrl .. "/Game/CreateFriend?firstUserId=%d&secondUserId=%d")
		game:GetService("FriendService"):SetBreakFriendUrl(assetGameUrl .. "/Game/BreakFriend?firstUserId=%d&secondUserId=%d")
		game:GetService("FriendService"):SetGetFriendsUrl(assetGameUrl .. "/Game/AreFriends?userId=%d")
	end
	game:GetService("BadgeService"):SetIsBadgeLegalUrl("")
	game:GetService("InsertService"):SetBaseSetsUrl(assetGameUrl .. "/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
	game:GetService("InsertService"):SetUserSetsUrl(assetGameUrl .. "/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
	game:GetService("InsertService"):SetCollectionUrl(assetGameUrl .. "/Game/Tools/InsertAsset.ashx?sid=%d")
	game:GetService("InsertService"):SetAssetUrl(assetGameUrl .. "/Asset/?id=%d")
	game:GetService("InsertService"):SetAssetVersionUrl(assetGameUrl .. "/Asset/?assetversionid=%d")
	
	if gameCode then
		pcall(function() loadfile(assetGameUrl .. "/Game/LoadPlaceInfo.ashx?PlaceId=" .. placeId .. "&gameCode=" .. tostring(gameCode))() end)
	else
		pcall(function() loadfile(assetGameUrl .. "/Game/LoadPlaceInfo.ashx?PlaceId=" .. placeId)() end)
	end
	
	pcall(function() 
				if access then
					loadfile(assetGameUrl .. "/Game/PlaceSpecificScript.ashx?PlaceId=" .. placeId)()
				end
			end)
end

pcall(function() game:GetService("NetworkServer"):SetIsPlayerAuthenticationRequired(true) end)
settings().Diagnostics.LuaRamLimit = 0

game:GetService("Players").PlayerAdded:connect(function(player)
	print("Player " .. player.userId .. " added")
	
	if assetGameUrl and access and placeId and player and player.userId then
		local didTeleportIn = "False"
		if player.TeleportedIn then didTeleportIn = "True" end

		game:HttpGet(assetGameUrl .. "/Game/ClientPresence.ashx?action=connect&PlaceID=" .. placeId .. "&UserID=" .. player.userId)
        if not isCloudEdit then
            game:HttpPost(assetGameUrl .. "/Game/PlaceVisit.ashx?UserID=" .. player.userId .. "&AssociatedPlaceID=" .. placeId .. "&placeVisitAccessKey=" .. placeVisitAccessKey .. "&IsTeleport=" .. didTeleportIn, "")
        end
	end
end)

game:GetService("Players").PlayerRemoving:connect(function(player)
	print("Player " .. player.userId .. " leaving")	

	local isTeleportingOut = "False"
	if player.Teleported then isTeleportingOut = "True" end

	if assetGameUrl and access and placeId and player and player.userId then
		game:HttpGet(assetGameUrl .. "/Game/ClientPresence.ashx?action=disconnect&PlaceID=" .. placeId .. "&UserID=" .. player.userId .. "&IsTeleport=" .. isTeleportingOut)
	end
end)

local onlyCallGameLoadWhenInRccWithAccessKey = newBadgeUrlEnabled
if placeId ~= nil and assetGameUrl ~= nil and ((not onlyCallGameLoadWhenInRccWithAccessKey) or access ~= nil) then
	-- yield so that file load happens in the heartbeat thread
	wait()
	
	-- load the game
	game:Load(assetGameUrl .. "/asset/?id=" .. placeId)
end

-- Configure CloudEdit saving after place has been loaded
if isCloudEdit then
	local doPeriodicSaves = true
	local delayBetweenSavesSeconds = 5 * 60 -- 5 minutes
	local function periodicSave()
		if doPeriodicSaves then
			game:ServerSave()
			delay(delayBetweenSavesSeconds, periodicSave)
		end
	end
	-- Spawn thread to save in the future
	delay(delayBetweenSavesSeconds, periodicSave)
	-- Hook into OnClose to save on shutdown
	game.OnClose = function()
		doPeriodicSaves = false
		game:ServerSave()
	end
end

-- Now start the connection
ns:Start(port, sleeptime) 

if timeout then
	scriptContext:SetTimeout(timeout)
end
scriptContext.ScriptsDisabled = false


-- StartGame --
if not isCloudEdit then
	if injectScriptAssetID and (injectScriptAssetID < 0) then
		pcall(function() Game:LoadGame(injectScriptAssetID * -1) end)
	else
		pcall(function() Game:GetService("ScriptContext"):AddStarterScript(injectScriptAssetID) end)
	end

	Game:GetService("RunService"):Run()
end

