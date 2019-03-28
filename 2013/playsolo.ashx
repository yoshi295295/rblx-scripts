%dj6Y+luuuriRIEyXAaGgWE69Z65Vimo/CSlM0ZPl0/ktC3iFqomxwOqo75ajS1yOkrnbIgpTz2z/ozCEqbXLp++YtB4sWzUrFCmVQo9a934H1VIusAcnnbT9jZQZ4fFxgCOTMYlbZuMliTnzO9oAJ8NV94Q1v2XMc7jXtShqPs0=%-- Prepended to Edit.lua and Visit.lua and Studio.lua and PlaySolo.lua--

function ifSeleniumThenSetCookie(key, value)
	if false then
		game:GetService("CookiesService"):SetCookieValue(key, value)
	end
end

ifSeleniumThenSetCookie("SeleniumTest1", "Inside the visit lua script")

if true then
	pcall(function() game:SetPlaceID(0) end)
else
	if 0>0 then
		pcall(function() game:SetPlaceID(0) end)
	end
end

visit = game:GetService("Visit")

local message = Instance.new("Message")
message.Parent = workspace
message.archivable = false

game:GetService("ScriptInformationProvider"):SetAssetUrl("http://www.roblox.com/Asset/")
game:GetService("ContentProvider"):SetThreadPool(16)
pcall(function() game:GetService("InsertService"):SetFreeModelUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?type=fm&q=%s&pg=%d&rs=%d") end) -- Used for free model search (insert tool)
pcall(function() game:GetService("InsertService"):SetFreeDecalUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?type=fd&q=%s&pg=%d&rs=%d") end) -- Used for free decal search (insert tool)

ifSeleniumThenSetCookie("SeleniumTest2", "Set URL service")

settings().Diagnostics:LegacyScriptMode()

game:GetService("InsertService"):SetBaseSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
game:GetService("InsertService"):SetUserSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
game:GetService("InsertService"):SetCollectionUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?sid=%d")
game:GetService("InsertService"):SetAssetUrl("http://www.roblox.com/Asset/?id=%d")
game:GetService("InsertService"):SetAssetVersionUrl("http://www.roblox.com/Asset/?assetversionid=%d")

pcall(function() game:GetService("SocialService"):SetFriendUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetBestFriendUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRankUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRoleUrl("http://www.roblox.com/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("GamePassService"):SetPlayerHasPassUrl("http://www.roblox.com/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d") end)
pcall(function() game:GetService("MarketplaceService"):SetProductInfoUrl("https://api.roblox.com/marketplace/productinfo?assetId=%d") end)
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

if true then
	pcall(function() game:HttpPost("https://api.roblox.com/auth/negotiate?ticket=", "negotiate") end)
	delay(300, function()
		while true do
			pcall(function() game:HttpPost("https://api.roblox.com/auth/renew", "renew") end)
			wait(300)
		end
	end)

	game.Close:connect(function() 
		pcall(function() game:HttpPost("https://api.roblox.com/auth/invalidate", "invalidate") end)
	end)
end

ifSeleniumThenSetCookie("SeleniumTest4", "Exiting SingleplayerSharedScript")-- SingleplayerSharedScript.lua inserted here --

pcall(function() settings().Rendering.EnableFRM = true end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)

game:GetService("ChangeHistoryService"):SetEnabled(false)
pcall(function() game:GetService("Players"):SetBuildUserPermissionsUrl("http://www.roblox.com//Game/BuildActionPermissionCheck.ashx?assetId=0&userId=%d&isSolo=true") end)

workspace:SetPhysicsThrottleEnabled(true)

local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")

function doVisit()
	message.Text = "Loading Game"
	if false then
		game:Load("")
		pcall(function() visit:SetUploadUrl("") end)
	else
	    pcall(function() visit:SetUploadUrl("") end)
	end
	

	message.Text = "Running"
	game:GetService("RunService"):Run()

	message.Text = "Creating Player"
	if false then
		player = game:GetService("Players"):CreateLocalPlayer(0)
		player.Name = [====[Guest 1702]====]
	else
		player = game:GetService("Players"):CreateLocalPlayer(0)
	end
	player.CharacterAppearance = "http://www.roblox.com/Asset/CharacterFetch.ashx?userId=1&placeId=0"
	player:LoadCharacter()

	message.Text = "Setting GUI"
	player:SetSuperSafeChat(true)
	pcall(function() player:SetUnder13(true) end)
	pcall(function() player:SetMembershipType(Enum.MembershipType.None) end)
	pcall(function() player:SetAccountAge(0) end)
	
	if false then
		message.Text = "Setting Ping"
		visit:SetPing("http://www.roblox.com/Game/ClientPresence.ashx?version=old&PlaceID=0", 300)

		message.Text = "Sending Stats"
		game:HttpGet("")
	end
	
end

success, err = pcall(doVisit)

if success then
	message.Parent = nil
else
	print(err)
	if false then
		pcall(function() visit:SetUploadUrl("") end)
	end
	wait(5)
	message.Text = "Error on visit: " .. err
	if false then
		game:HttpPost("http://www.roblox.com/Error/Lua.ashx?", "PlaySolo.lua: " .. err)
	end
end

