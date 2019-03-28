%FiiBFvrH44Om+hnEmEdooUhK0u9W3W40KW6AdUKVv2wchla/rP3PpNf6pvXcdxsJxUkmtmZR3qp8qX6urrsD7iO25U+9No0gSRhBW9BJAU7SO55WJs/3PyKwcDgBJvukLaq8wWNHO2ej9BXc201cOaf+bCFxjyBg+0CwPSV4BkU=%

-- functions --------------------------
function onPlayerAdded(player)
	-- override
end



-- MultiplayerSharedScript.lua inserted here ------ Prepended to GroupBuild.lua and Join.lua --

-- log app init time
pcall(function()
	local t = ElapsedTime()
	local platform = settings().Diagnostics.OsPlatform
	game:HttpGet("http://www.roblox.com/Game/JoinRate.ashx?st=0&i=0&p=-1&c=GameAppInit&r=Success&d=" .. (math.floor(t*1000)) .. "&ip=localhost&errorType=&platform=" .. platform, false)
end)

pcall(function() game:SetPlaceID(-1, false) end)

local startTime = tick()
local connectResolved = false
local loadResolved = false
local joinResolved = false
local playResolved = true
local playStartTime = 0

local cdnSuccess = 0
local cdnFailure = 0

settings()["Game Options"].CollisionSoundEnabled = true
pcall(function() settings().Rendering.EnableFRM = true end)
pcall(function() settings().Physics.Is30FpsThrottleEnabled = true end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)
pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto end)

function reportContentProvider(time, queueLength, blocking)
	pcall(function()
		game:HttpGet("http://www.roblox.com/Analytics/ContentProvider.ashx?t=" .. time .. "&ql=" .. queueLength, blocking)
	end)
end
function reportCdn(blocking)
	pcall(function()
		local newCdnSuccess = settings().Diagnostics.CdnSuccessCount
		local newCdnFailure = settings().Diagnostics.CdnFailureCount
		local successDelta = newCdnSuccess - cdnSuccess
		local failureDelta = newCdnFailure - cdnFailure
		cdnSuccess = newCdnSuccess
		cdnFailure = newCdnFailure
		if successDelta > 0 or failureDelta > 0 then
			game:HttpGet("http://www.roblox.com/Game/Cdn.ashx?source=client&success=" .. successDelta .. "&failure=" .. failureDelta, blocking)
		end
	end)
end

function reportDuration(category, result, duration, blocking,errorType)
	if not errorType then
		errorType = ''
	end
	local platform = settings().Diagnostics.OsPlatform
	local bytesReceived = -1
	if stats().Network:getChildren()[2] ~= nil then
		bytesReceived = stats().Network:getChildren()[2].Stats.totalBytesReceived:GetValue()
	end
	pcall(function() game:HttpGet("http://www.roblox.com/Game/JoinRate.ashx?st=0&i=0&p=-1&c=" .. category .. "&r=" .. result .. "&d=" .. (math.floor(duration*1000)) .. "&b=" .. bytesReceived .. "&ip=localhost&errorType=" .. errorType .. "&platform=" .. platform, blocking) end)
end
-- arguments ---------------------------------------
local threadSleepTime = ...

if threadSleepTime==nil then
	threadSleepTime = 15
end

local test = true

print("! Joining game '' place -1 at localhost")
local closeConnection = game.Close:connect(function() 
	if 0 then
		reportCdn(true)
		if not connectResolved then
			local duration = tick() - startTime;
			reportDuration("GameConnect", "Failure", duration, true)
		elseif (not loadResolved) or (not joinResolved) then
			local duration = tick() - startTime;
			if not loadResolved then
				loadResolved = true
				reportDuration("GameLoad","Cancel", duration, true)
			end
			if not joinResolved then
				joinResolved = true
				reportDuration("GameJoin","Cancel", duration, true)
			end
		elseif not playResolved then
			local duration = tick() - playStartTime;
			playResolved = true
			reportDuration("GameDuration","Success", duration, true)
		end
		pcall(function() game:HttpGet("&disconnect=true", true) end)
		if true then pcall(function() game:HttpPost("https://api.roblox.com/auth/invalidate", "invalidate") end) end
	end
end)

game:GetService("ChangeHistoryService"):SetEnabled(false)
game:GetService("ContentProvider"):SetThreadPool(16)
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

-- Bubble chat.  This is all-encapsulated to allow us to turn it off with a config setting
pcall(function() game:GetService("Players"):SetChatStyle(Enum.ChatStyle.Classic) end)

local waitingForCharacter = false
local waitingForCharacterGuid = "26c3de03-3381-4ab6-8e60-e415fa757eba";
pcall( function()
	if settings().Network.MtuOverride == 0 then
	  settings().Network.MtuOverride = 1400
	end
end)


-- globals -----------------------------------------

client = game:GetService("NetworkClient")
visit = game:GetService("Visit")

-- functions ---------------------------------------
function ifSeleniumThenSetCookie(key, value)
	if false then
		game:GetService("CookiesService"):SetCookieValue(key, value)
	end
end

function setMessage(message)
	-- todo: animated "..."
	if not false then
		game:SetMessage(message)
	else
		-- hack, good enought for now
		game:SetMessage("Teleporting ...")
	end
end

function showErrorWindow(message, errorType, errorCategory)
	if 0 then
		if (not loadResolved) or (not joinResolved) then
			local duration = tick() - startTime;
			if not loadResolved then
				loadResolved = true
				reportDuration("GameLoad","Failure", duration, false,errorType)
			end
			if not joinResolved then
				joinResolved = true
				reportDuration("GameJoin",errorCategory, duration, false,errorType)
			end
			
			pcall(function() game:HttpGet("?FilterName=Type&FilterValue=" .. errorType .. "&Type=JoinFailure", false) end)
		elseif not playResolved then
			local duration = tick() - playStartTime;
			playResolved = true
			reportDuration("GameDuration",errorCategory, duration, false,errorType)

			pcall(function() game:HttpGet("?FilterName=Type&FilterValue=" .. errorType .. "&Type=GameDisconnect", false) end)
		end
	end
	
	game:SetMessage(message)
end

function registerPlay(key)
	if true and game:GetService("CookiesService"):GetCookieValue(key) == "" then
		game:GetService("CookiesService"):SetCookieValue(key, "{ \"userId\" : 0, \"placeId\" : -1, \"os\" : \"" .. settings().Diagnostics.OsPlatform .. "\" }")
	end
end

function analytics(name)
	if not test and false then 
		pcall(function() game:HttpGet("?IPFilter=Primary&SecondaryFilterName=UserId&SecondaryFilterValue=0&Type=" .. name, false) end)
	end
end

function analyticsGuid(name, guid)
	if not test and false then 
		pcall(function() game:HttpGet("?IPFilter=Primary&SecondaryFilterName=guid&SecondaryFilterValue=" .. guid .. "&Type=" .. name, false) end)
	end
end

function reportError(err, message)
	print("***ERROR*** " .. err)
	if not test then visit:SetUploadUrl("") end
	client:Disconnect()
	wait(4)
	showErrorWindow("Error: " .. err, message, "Other")
end

-- called when the client connection closes
function onDisconnection(peer, lostConnection)
	if lostConnection then
	    if waitingForCharacter then analyticsGuid("Waiting for Character Lost Connection",waitingForCharacterGuid) end
		showErrorWindow("You have lost the connection to the game", "LostConnection", "LostConnection")
	else
	    if waitingForCharacter then analyticsGuid("Waiting for Character Game Shutdown",waitingForCharacterGuid) end
		showErrorWindow("This game has shut down", "Kick", "Kick")
	end
	pcall(function() game:HttpGet("&disconnect=true", true) end)
	if true then pcall(function() game:HttpPost("https://api.roblox.com/auth/invalidate", "invalidate") end) end
end

function requestCharacter(replicator)
	
	-- prepare code for when the Character appears
	local connection
	connection = player.Changed:connect(function (property)
		if property=="Character" then
			game:ClearMessage()
			waitingForCharacter = false
			analyticsGuid("Waiting for Character Success", waitingForCharacterGuid)
			
			connection:disconnect()
		
			if 0 then
				if not joinResolved then
					local duration = tick() - startTime;
					joinResolved = true
					reportDuration("GameJoin","Success", duration, false)
					
					playStartTime = tick()
					playResolved = false
				end
			end
		end
	end)
	
	setMessage("Requesting character")
	
	if 0 and not loadResolved then
		local duration = tick() - startTime;
		loadResolved = true
		reportDuration("GameLoad","Success", duration, false)
	end

	local success, err = pcall(function()	
		replicator:RequestCharacter()
		setMessage("Waiting for character")
		waitingForCharacter = true
		analyticsGuid("Waiting for Character Begin",waitingForCharacterGuid);
	end)
	if not success then
		reportError(err,"W4C")
		return
	end
end

-- called when the client connection is established
function onConnectionAccepted(url, replicator)
	connectResolved = true
	reportDuration("GameConnect", "Success", tick() - startTime, false)

	local waitingForMarker = true
	
	local success, err = pcall(function()	
		if not test then 
		    visit:SetPing("", 300) 
		end
		
		if not false then
			game:SetMessageBrickCount()
		else
			setMessage("Teleporting ...")
		end

		replicator.Disconnection:connect(onDisconnection)
		
		-- Wait for a marker to return before creating the Player
		local marker = replicator:SendMarker()
		
		marker.Received:connect(function()
			waitingForMarker = false
			requestCharacter(replicator)
		end)
	end)
	
	if not success then
		reportError(err,"ConnectionAccepted")
		return
	end
	
	-- TODO: report marker progress
	
	while waitingForMarker do
		workspace:ZoomToExtents()
		wait(0.5)
	end
end

-- called when the client connection fails
function onConnectionFailed(_, error)
	showErrorWindow("Failed to connect to the Game. (ID=" .. error .. ")", "ID" .. error, "Other")
end

-- called when the client connection is rejected
function onConnectionRejected()
	connectionFailed:disconnect()
	showErrorWindow("This game is not available. Please try another", "WrongVersion", "WrongVersion")
end

idled = false
function onPlayerIdled(time)
	if time > 20*60 then
		showErrorWindow(string.format("You were disconnected for being idle %d minutes", time/60), "Idle", "Idle")
		client:Disconnect()	
		if not idled then
			idled = true
		end
	end
end


-- main ------------------------------------------------------------

analytics("Start Join Script")

ifSeleniumThenSetCookie("SeleniumTest1", "Started join script")

pcall(function() settings().Diagnostics:LegacyScriptMode() end)
local success, err = pcall(function()	

	game:SetRemoteBuildMode(true)
	
	setMessage("Connecting to Server")
	client.ConnectionAccepted:connect(onConnectionAccepted)
	client.ConnectionRejected:connect(onConnectionRejected)
	connectionFailed = client.ConnectionFailed:connect(onConnectionFailed)
	client.Ticket = ""	
	ifSeleniumThenSetCookie("SeleniumTest2", "Successfully connected to server")
	
	playerConnectSucces, player = pcall(function() return client:PlayerConnect(0, "localhost", 53640, 0, threadSleepTime) end)
	if not playerConnectSucces then
		--Old player connection scheme
		player = game:GetService("Players"):CreateLocalPlayer(0)
		analytics("Created Player")
		client:Connect("localhost", 53640, 0, threadSleepTime)
	else
		analytics("Created Player")
	end

	pcall(function()
		registerPlay("rbx_evt_ftp")
		delay(60*5, function() registerPlay("rbx_evt_fmp") end)
	end)

	-- negotiate an auth token
	if true then
		pcall(function() game:HttpPost("https://api.roblox.com/auth/negotiate?ticket=", "negotiate") end)
		delay(300, function()
			while true do
				pcall(function() game:HttpPost("https://api.roblox.com/auth/renew", "renew") end)
				wait(300)
			end
		end)
	end

	player:SetSuperSafeChat(true)
	pcall(function() player:SetUnder13(true) end)
	pcall(function() player:SetMembershipType(Enum.MembershipType.None) end)
	pcall(function() player:SetAccountAge(0) end)
	player.Idled:connect(onPlayerIdled)
	
	-- Overriden
	onPlayerAdded(player)
	
	pcall(function() player.Name = [========[Player]========] end)
	player.CharacterAppearance = ""	
	if not test then visit:SetUploadUrl("")end
	
	analytics("Connect Client")
		
end)

if not success then
	reportError(err,"CreatePlayer")
end

ifSeleniumThenSetCookie("SeleniumTest3", "Successfully created player")

if not test then
	-- TODO: Async get?
	loadfile("")("", -1, 0)
end

if 0 then
 delay(60*5, function()
	while true do
		reportCdn(false)
		wait(60*5)
	end
 end)
 local cpTime = 30
 delay(cpTime, function()
    while cpTime <= 480 do 
	   reportContentProvider(cpTime, game:GetService("ContentProvider").RequestQueueSize, false)
       wait(cpTime)
       cpTime = cpTime * 2
    end
 end) 
end

pcall(function() game:SetScreenshotInfo("") end)
pcall(function() game:SetVideoInfo('<?xml version="1.0"?><entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007"><media:group><media:title type="plain"><![CDATA[ROBLOX Place]]></media:title><media:description type="plain"><![CDATA[ For more games visit http://www.roblox.com]]></media:description><media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Games</media:category><media:keywords>ROBLOX, video, free game, online virtual world</media:keywords></media:group></entry>') end)
-- use single quotes here because the video info string may have unescaped double quotes

analytics("Join Finished")

ifSeleniumThenSetCookie("SeleniumTest4", "Finished join")
