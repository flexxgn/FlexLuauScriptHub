-- Script in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rainModel = ReplicatedStorage:WaitForChild("Rain")


local function toggleRain(enable)
    if enable then
        if not workspace:FindFirstChild("Rain") then
            local rainClone = rainModel:Clone()
            rainClone.Parent = workspace
        end
    else
        local rainInWorkspace = workspace:FindFirstChild("Rain")
        if rainInWorkspace then
            rainInWorkspace:Destroy()
        end
    end
end


local function onPlayerChatted(player, message)
    if message:lower() == ":rain on" then
        toggleRain(true)
    elseif message:lower() == ":rain off" then
        toggleRain(false)
    end
end


Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)