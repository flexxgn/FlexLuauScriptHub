local UserInputService = game:GetService("UserInputService")

local function act()
    
    local character = game.Players.LocalPlayer.Character
    if character then
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            
            local tool = humanoid.Parent:FindFirstChildWhichIsA("Tool")
            if tool then
                while true do
                    wait(0.01)
                    tool:Activate()  
                end
                
            end
        end
    end
end

-- ac script btw ^^ n this script works for studios cuz im js pro.
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == Enum.KeyCode.E then
        act()
    end
end)
