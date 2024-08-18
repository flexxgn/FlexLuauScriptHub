local ServerScriptService = game:GetService("ServerScriptService")
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
local commandOff = true

function setData(plr,name,color)
    plr:SetExtraData('Tags', {{TagText = name, TagColor = color }})
end

function getRanks(plrName)
    local plr = game:GetService("Players"):FindFirstChild(plrName)
    return plr:GetRankInGroup(nil) -- group id to put
end

ChatService.SpeakerAdded:Connect(function(PlrName)
    if commandOff == true  then
        local Speaker = ChatService:GetSpeaker(PlrName)
        if getRanks(PlrName) == 7 then
            setData(Speaker,"",Color3.fromRGB(255, 138, 253))
        end
        if getRanks(PlrName) == 8 then
            setData(Speaker,"",Color3.fromRGB(242, 2, 198))
        end
        if getRanks(PlrName) == 9 then
            setData(Speaker,"",Color3.fromRGB(194, 14, 35))
        end
        if getRanks(PlrName) == 110 then
            setData(Speaker,"",Color3.fromRGB(0, 0, 0))
        end
        if getRanks(PlrName) == 210 then
            setData(Speaker,"",Color3.fromRGB(134, 40, 222))
        end
    else
        print("ITS OFF")
    end
end)
