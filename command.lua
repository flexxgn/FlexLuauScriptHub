local Market = game:service'MarketplaceService'

local Commands = {}
local Events = {}

GetResult = function(Player)
	for Index,Command in next,Commands do
		for _,ProductId in next,Command.List do
			do
				if(Market:UserOwnsGamePassAsync(Player.userId, ProductId))then
					return 1
				end
			end
		end
	end
	return 1
end

GetCommand = function(Player, Message)
	for Index,Command in next,Commands do
		if(Message:lower():sub(1,#Command.Alias) == Command.Alias)then
			for Library,ProductId in next,Command.List do
				if(Market:UserOwnsGamePassAsync(Player.userId, ProductId))then
					Command.Call(Player, Message:sub(#Command.Alias+1))
				end
			end
		end
	end
	return 0
end

CreateNewCommand = function(CommandName, Restriction, Function)
	Commands[#Commands + 1] = {Alias = CommandName, List = Restriction, Call = Function}
end

CreateNewCommand('!item ', {24631077}, function(Speaker, Identity)
	local GetCount = function(Character)
		local Result = 0
		for Index, Accessories in next,Character:children''do
			if Accessories:isA'Accessory'then
				Result = Result + 1
			end
		end
		return Result
	end
	if(GetCount(Speaker.Character) >= 20)then
		for Index, Kill in next, Speaker.Character:children''do
			if Kill:isA'Accessory'then
				Kill:destroy()
			end
		end
	end
	local Hat = game:service'InsertService':LoadAsset(tonumber(Identity)):children()[1]
	if(Hat.className == 'Accessory')then
		Hat.Parent = Speaker.Character
	else
		Hat:Destroy()
		warn(('%s has tried to insert a non-hat based object...'):format(Speaker.Name))
	end
end)

Edit = function(Player, Object, Index)
	for Sector, Properties in next,Index do
		Player:FindFirstChild'Settings'[Object][Sector] = Properties
	end
	return Object
end

CreateNewCommand('!tag ', {5560472,5673416}, function(Speaker, Identity)
	Edit(Speaker, 'Groupcolor', {Value = true})
	Edit(Speaker, 'Clan', {Value = game:service'Chat':FilterStringAsync(Identity, Speaker, Speaker)})
end)

CreateNewCommand('!chatmenu', {5673416}, function(Speaker, Identity)
	do
		pcall(function()
			script:children()[1]:clone().Parent = Speaker.PlayerGui
		end)
	end
end)

game:service'Players'.playerAdded:connect(function(Player)
	if(Player ~= nil)then
		do
			if(GetResult(Player) == 1)then
				Player.Chatted:connect(function(Msg)
					GetCommand(Player, Msg)
				end)
			end
		end
	end
end)

local FlushCommand = Instance.new('RemoteEvent', game:service'ReplicatedStorage')

FlushCommand.Name = 'Instructions'

FlushCommand.OnServerEvent:connect(function(Player, Message)
	GetCommand(Player, Message)
end)

for Index, Methods in next,{'PromptPurchaseFinished', 'PromptGamePassPurchaseFinished'}do
	Market[Methods]:connect(function(Player, Level, Finished)
		if(Finished)then
			Player.Chatted:connect(function(Message)
				GetCommand(Player, Message)
			end)
		end
	end)

end

CreateNewCommand(':nick ', {5673416}, function(Speaker, Identity)
	if(Identity:len() > 21)then
		return(warn(('%s this name is too long to be used, tags need to be short')):format(Speaker.Name))
	end
	do
		pcall(function()
			Speaker:FindFirstChild'Settings':FindFirstChild'Name'.Value =  game:service'Chat':FilterStringAsync(Identity, Speaker, Speaker)
		end)
	end
end)
