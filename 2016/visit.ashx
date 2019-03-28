--rbxsig%AXFftZPXWdeJMObbs/j6g7DFTRg8tbVWwmOrO1FJ/fj3cAwtygnPMV0pSowugAAQ7n8OOrWnqunz+WV3Rk/k7nenk7PdlXc3IB/CCrriPH500aak0CdY5B0g78913XXuenRx/PSFLT7qcDdxNdx89yXkiNna7AiBlsPUlGf5TsQ=%
-- Prepended to Edit.lua and Visit.lua and Studio.lua and PlaySolo.lua--

function ifSeleniumThenSetCookie(key, value)
	if false then
		game:GetService("CookiesService"):SetCookieValue(key, value)
	end
end

ifSeleniumThenSetCookie("SeleniumTest1", "Inside the visit lua script")

pcall(function() game:SetPlaceID(0) end)
pcall(function() game:SetUniverseId(0) end)

visit = game:GetService("Visit")

local message = Instance.new("Message")
message.Parent = workspace
message.archivable = false

game:GetService("ScriptInformationProvider"):SetAssetUrl("http://assetgame.roblox.com/Asset/")
game:GetService("ContentProvider"):SetThreadPool(16)
pcall(function() game:GetService("InsertService"):SetFreeModelUrl("http://assetgame.roblox.com/Game/Tools/InsertAsset.ashx?type=fm&q=%s&pg=%d&rs=%d") end) -- Used for free model search (insert tool)
pcall(function() game:GetService("InsertService"):SetFreeDecalUrl("http://assetgame.roblox.com/Game/Tools/InsertAsset.ashx?type=fd&q=%s&pg=%d&rs=%d") end) -- Used for free decal search (insert tool)

ifSeleniumThenSetCookie("SeleniumTest2", "Set URL service")

settings().Diagnostics:LegacyScriptMode()

game:GetService("InsertService"):SetBaseSetsUrl("http://assetgame.roblox.com/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
game:GetService("InsertService"):SetUserSetsUrl("http://assetgame.roblox.com/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
game:GetService("InsertService"):SetCollectionUrl("http://assetgame.roblox.com/Game/Tools/InsertAsset.ashx?sid=%d")
game:GetService("InsertService"):SetAssetUrl("http://assetgame.roblox.com/Asset/?id=%d")
game:GetService("InsertService"):SetAssetVersionUrl("http://assetgame.roblox.com/Asset/?assetversionid=%d")

pcall(function() game:GetService("SocialService"):SetFriendUrl("http://assetgame.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetBestFriendUrl("http://assetgame.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupUrl("http://assetgame.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRankUrl("http://assetgame.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRoleUrl("http://assetgame.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("GamePassService"):SetPlayerHasPassUrl("http://assetgame.roblox.com/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d") end)
pcall(function() game:GetService("MarketplaceService"):SetProductInfoUrl("https://api.roblox.com/marketplace/productinfo?assetId=%d") end)
pcall(function() game:GetService("MarketplaceService"):SetDevProductInfoUrl("https://api.roblox.com/marketplace/productDetails?productId=%d") end)
pcall(function() game:GetService("MarketplaceService"):SetPlayerOwnsAssetUrl("https://api.roblox.com/ownership/hasasset?userId=%d&assetId=%d") end)
pcall(function() game:SetCreatorID(0, Enum.CreatorType.User) end)

ifSeleniumThenSetCookie("SeleniumTest3", "Set creator ID")

pcall(function() game:SetScreenshotInfo("") end)
pcall(function() game:SetVideoInfo("") end)

function registerPlay(key)
	if true and game:GetService("CookiesService"):GetCookieValue(key) == "" then
		game:GetService("CookiesService"):SetCookieValue(key, "{ \"userId\" : 0, \"placeId\" : 0, \"os\" : \"" .. settings().Diagnostics.OsPlatform .. "\"}")
	end
end

pcall(function()
	registerPlay("rbx_evt_ftp")
	delay(60*5, function() registerPlay("rbx_evt_fmp") end)
end)

ifSeleniumThenSetCookie("SeleniumTest4", "Exiting SingleplayerSharedScript")-- SingleplayerSharedScript.lua inserted here --

pcall(function() settings().Rendering.EnableFRM = true end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)

game:GetService("ChangeHistoryService"):SetEnabled(false)
pcall(function() game:GetService("Players"):SetBuildUserPermissionsUrl("http://www.roblox.com//Game/BuildActionPermissionCheck.ashx?assetId=0&userId=%d&isSolo=true") end)

workspace:SetPhysicsThrottleEnabled(true)

local addedBuildTools = false
local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")

local inStudio = false or false

function doVisit()
	message.Text = "Loading Game"
	if false then
		if false then
			success, err = pcall(function() game:Load("") end)
			if not success then
				message.Text = "Could not teleport"
				return
			end
		end
	else
		if false then
			game:Load("")
			pcall(function() visit:SetUploadUrl("") end)
		else
			pcall(function() visit:SetUploadUrl("") end)
		end
	end

	message.Text = "Running"
	game:GetService("RunService"):Run()

	message.Text = "Creating Player"
	if false or false then
		player = game:GetService("Players"):CreateLocalPlayer(0)
		if not inStudio then
			player.Name = [====[Guest 1473]====]
		end
	else
		player = game:GetService("Players"):CreateLocalPlayer(0)
	end
	player.CharacterAppearance = "http://assetgame.roblox.com/Asset/CharacterFetch.ashx?userId=1&placeId=0"
	local propExists, canAutoLoadChar = false
	propExists = pcall(function()  canAutoLoadChar = game.Players.CharacterAutoLoads end)

	if (propExists and canAutoLoadChar) or (not propExists) then
		player:LoadCharacter()
	end
	
	message.Text = "Setting GUI"
	player:SetSuperSafeChat(true)
	pcall(function() player:SetUnder13(True) end)
	pcall(function() player:SetMembershipType(None) end)
	pcall(function() player:SetAccountAge(0) end)
	
	if not inStudio and false then
		message.Text = "Setting Ping"
		visit:SetPing("http://assetgame.roblox.com/Game/ClientPresence.ashx?version=old&PlaceID=0", 120)

		message.Text = "Sending Stats"
		game:HttpGet("")
	end
	
end

success, err = pcall(doVisit)

if not inStudio and not addedBuildTools then
	local playerName = Instance.new("StringValue")
	playerName.Name = "PlayerName"
	playerName.Value = player.Name
	playerName.RobloxLocked = true
	playerName.Parent = screenGui
				
	pcall(function() game:GetService("ScriptContext"):AddCoreScript(59431535,screenGui,"BuildToolsScript") end)
	addedBuildTools = true
end

if success then
	message.Parent = nil
else
	print(err)
	if not inStudio then
		if false then
			pcall(function() visit:SetUploadUrl("") end)
		end
	end
	wait(5)
	message.Text = "Error on visit: " .. err
	if not inStudio then
		if false then
			game:HttpPost("https://data.roblox.com/Error/Lua.ashx", "Visit.lua: " .. err)
		end
	end
end

