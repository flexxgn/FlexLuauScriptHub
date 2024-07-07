-- this is an esp 
-- Configuration
local keyBind = Enum.KeyCode.F  -- Keybind to activate ESP
local espDistance = 500         -- Distance

-- Function to create ESP indicators
local function createIndicator(player)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 4, 0, 4)  
    indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  
    indicator.BorderSizePixel = 0
    indicator.Name = "ESP"
    
    indicator.Parent = game.CoreGui
    
    -- Update position function
    local function updatePosition()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen then
                indicator.Visible = true
                indicator.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
            else
                indicator.Visible = false
            end
        else
            indicator.Visible = false
        end
    end
    
    
    updatePosition()
    game:GetService("RunService").RenderStepped:Connect(updatePosition)
end


local function updateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createIndicator(player)
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == keyBind then
        updateESP()
    end

game.Players.PlayerRemoving:Connect(function(player)
    local gui = game.CoreGui:FindFirstChild(player.Name)
    if gui then
        gui:Destroy()
    end
end)

