local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local lazy = require(ReplicatedStorage:WaitForChild("lazy"))
local maps = require(ReplicatedStorage:WaitForChild("maps"))
local swords = require(ReplicatedStorage:WaitForChild("swords"))
local message = require(ServerScriptService.message)
local create = lazy.create

local winsStore = DataStoreService:GetOrderedDataStore("Win")
local killsStore = DataStoreService:GetOrderedDataStore("Kill")
local dataStore = DataStoreService:GetDataStore("Data")

local function setupData(player)
	local data = create("Configuration", {Name = "Data"; Parent = player;}, {
		create("IntValue", {Name = "ArenaID"});
		create("IntValue", {
			Name = "EquippedSword";
			Value = 1;
		});
		create("BoolValue", {Name = "PadObject"});
		create("Folder", {Name = "Results"});
		create("Folder", {Name = "Match";}, {
			create("IntValue", {Name = "Kills"});
			create("IntValue", {Name = "Deaths"});
			create("Folder", {Name = "Enemies"});
		});
	})
	
	local flags = create("Configuration", {Name = "Flags"; Parent = player;}, {
		create("BoolValue", {Name = "IsInMatch"});
		create("BoolValue", {Name = "IsAFK"});
		create("BoolValue", {Name = "CanStart"});
		create("BoolValue", {Name = "IsOnPad"});
		create("BoolValue", {Name = "HasDataLoaded"});
	})
	
	local stats = create("Configuration", {Name = "Stats"; Parent = player;}, {
		create("IntValue", {Name = "Coins"; Value = 0});
		create("Folder", {Name = "Swords"});
		create("Folder", {Name = "Maps"});
		create("Folder", {Name = "AllTime";}, {
			create("IntValue", {Name = "Kills"});
			create("IntValue", {Name = "Deaths"});
			create("IntValue", {Name = "Wins"});
			create("IntValue", {Name = "Losses"});
			create("IntValue", {Name = "Rating"});
		});
		create("Folder", {Name = "Session";}, {
			create("IntValue", {Name = "Kills"});
			create("IntValue", {Name = "Deaths"});
			create("IntValue", {Name = "Wins"});
			create("IntValue", {Name = "Losses"});
		})
	})
	
	for _,v in next, swords.defaultSwords do
		create("IntValue", {Name = v; Value = v; Parent = player.Stats.Swords})
	end

	for _,v in next, maps.defaultMaps do
		create("IntValue", {Name = v; Value = v; Parent = player.Stats.Maps})
	end
	
	local key = "plr-" .. tostring(player.UserId)

	
	
	local data_kills
	local data_wins
	local data_main
	
	local _, e = ypcall(function()
		data_kills = killsStore:GetAsync(key)
		data_wins = winsStore:GetAsync(key)
		
		data_main = dataStore:GetAsync(key) 
	end)
	
	
	
	stats.AllTime.Kills.Value = data_kills or 0
	stats.AllTime.Wins.Value = data_wins or 0
	
	if (data_main ~= nil) then 
		stats.AllTime.Deaths.Value = data_main.Deaths or 0 
		stats.AllTime.Losses.Value = data_main.Losses or 0 
		stats.Coins.Value = data_main.Cash or 0
		data.EquippedSword.Value = data_main.EquippedSword or 1
		
		if (data_main.Inventory ~= nil) then
			for _, sword in next, data_main.Inventory do
				create("IntValue", {Name = sword, Value = sword, Parent = stats.Swords})
			end
		end
		
		if (data_main.Maps ~= nil) then
			for _, map in next, data_main.Maps do
				create("IntValue", {Name = map, Value = map, Parent = stats.Maps})
			end
		end
	end
	
	player.Flags.HasDataLoaded.Value = true 
	
	player.CharacterAdded:connect(function(c)
		local hum = c:WaitForChild("Humanoid")
		
		hum.Died:connect(function()
			local round = c:FindFirstChild("Round")
			
			if round then
				round:Destroy()
			end
		end)
	end)
end

local function saveData(player)
	if player then
		local keyString = "plr-" .. tostring(player.UserId)
		local _maps = {}
		local _swords = {}
		
		local function isInTable(tbl, val)
			for _, v in next, tbl do
				if v == val then
					return true
				end
			end
			
			return false
		end
		
		for _,v in next, player.Stats.Swords:GetChildren() do
			if not isInTable(swords.defaultSwords, v.Value) then
				table.insert(_swords, v.Value)
			end
		end
		
		for _,v in next, player.Stats.Maps:GetChildren() do
			if not isInTable(maps.defaultMaps, v.Value) then
				table.insert(_maps, v.Value)
			end
		end
		
		killsStore:SetAsync(keyString, player.Stats.AllTime.Kills.Value)
		winsStore:SetAsync(keyString, player.Stats.AllTime.Wins.Value)
		dataStore:SetAsync(keyString, {
			Deaths = player.Stats.AllTime.Deaths.Value,
			Losses = player.Stats.AllTime.Losses.Value,
			Cash = player.Stats.Coins.Value;
			EquippedSword = player.Data.EquippedSword.Value;
			Maps = _maps;
			Inventory = _swords;
		})
	end
end

Players.PlayerAdded:connect(function(player)
	setupData(player)
	
	for _,v in next, Players:GetPlayers() do
		message:make(v, player.Name.." has joined the game", Color3.new(0, 0.333333, 0.498039))
	end
	
	while (player.Parent == Players) and wait(120) do
		saveData(player)
	end
end)

Players.PlayerRemoving:connect(function(player)
	wait()
	saveData(player)
	
	for _,v in next, Players:GetPlayers() do
		message:make(v, player.Name.." has left the game :c", Color3.new(0, 0.333333, 0.498039))
	end
end)
