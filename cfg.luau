repeat task.wait() until game:IsLoaded()

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerCharacter = player.Character
local playerCamera = Workspace.CurrentCamera

local TargetedPlayer = nil
local TargetedPlayerCharacter = nil
local TargetedPlayerAimPart = nil

local Silent = {
    Settings = {
        Toggled = true,
        AimPart = "UpperTorso",
        HitChance = 500000,
        Prediction = {
            Toggled = true,
            Horizontal = 0.12880,
            Vertical = 0.12880,
        },
        Circle = {
            Visible = false,
            Color = Color3.fromRGB(0, 255, 255),
            Transparency = 0.5,
            Thickness = 1,
            NumSides = 100,
            Radius = 70, -- Adjust the FOV circle radius as needed
            Filled = false,
        },
    },
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = Silent.Settings.Circle.Visible
FOVCircle.Color = Silent.Settings.Circle.Color
FOVCircle.Transparency = Silent.Settings.Circle.Transparency
FOVCircle.Thickness = Silent.Settings.Circle.Thickness
FOVCircle.NumSides = Silent.Settings.Circle.NumSides
FOVCircle.Radius = Silent.Settings.Circle.Radius
FOVCircle.Filled = Silent.Settings.Circle.Filled

local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = math.huge

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= player and Player.Character then
            local PlayerPart = Player.Character:FindFirstChild(Silent.Settings.AimPart)
            if PlayerPart and PlayerPart:IsA("BasePart") then
                local PlayerScreenPosition = playerCamera:WorldToViewportPoint(PlayerPart.Position)
                local MagnitudeDistance = (Vector2.new(PlayerScreenPosition.X, PlayerScreenPosition.Y) - Vector2.new(playerCamera.ViewportSize.X / 2, playerCamera.ViewportSize.Y / 2)).Magnitude
                
                if MagnitudeDistance <= FOVCircle.Radius then
                    ClosestPlayer = Player
                    ShortestDistance = MagnitudeDistance
                end
            end
        end
    end
    return ClosestPlayer
end

RunService.RenderStepped:Connect(function()
    TargetedPlayer = GetClosestPlayer()
    if TargetedPlayer and TargetedPlayer.Character and TargetedPlayer.Character:WaitForChild(Silent.Settings.AimPart) then
        TargetedPlayerCharacter = TargetedPlayer.Character
        TargetedPlayerAimPart = TargetedPlayerCharacter:WaitForChild(Silent.Settings.AimPart)
    end
    
    FOVCircle.Position = Vector2.new(playerCamera.ViewportSize.X / 2, playerCamera.ViewportSize.Y / 2)
end)

local RawMetaTable = getrawmetatable(game)
local OldRawMetaTable = RawMetaTable.__namecall
setreadonly(RawMetaTable, false)

math.randomseed(os.time())

RawMetaTable.__namecall = newcclosure(function(...)
    local RemoteArguments = {...}

    if Silent.Settings.Toggled and getnamecallmethod() == "FireServer" and TargetedPlayer and TargetedPlayerCharacter and TargetedPlayerAimPart then
        local VelocityPrediction = Vector3.new(TargetedPlayerAimPart.Velocity.X * Silent.Settings.Prediction.Horizontal, TargetedPlayerAimPart.Velocity.Y * Silent.Settings.Prediction.Vertical, TargetedPlayerAimPart.Velocity.Z * Silent.Settings.Prediction.Horizontal)
        local Hit_Success = math.random(100) <= Silent.Settings.HitChance
        
        if (RemoteArguments[2] == "UpdateMousePos" and type(RemoteArguments[3]) ~= "table") or (RemoteArguments[2] == "MousePos" and type(RemoteArguments[3]) ~= "table") or (RemoteArguments[2] == "MOUSE" and type(RemoteArguments[3]) ~= "table") then 
            
            if Hit_Success then
                if Silent.Settings.Prediction.Toggled then
                    RemoteArguments[3] = TargetedPlayerAimPart.Position + VelocityPrediction
                elseif not Silent.Settings.Prediction.Toggled then
                    RemoteArguments[3] = TargetedPlayerAimPart.Position
                end
            end
            
        elseif (RemoteArguments[2] == "UpdateMousePos" and type(RemoteArguments[3]) == "table" and RemoteArguments[3]["MousePos"] and RemoteArguments[3]["Camera"] and not RemoteArguments[3][1] and not RemoteArguments[3][2]) then
            
            if Hit_Success then
                if Silent.Settings.Prediction.Toggled then
                    RemoteArguments[3] = {
                        ["MousePos"] = TargetedPlayerAimPart.Position + VelocityPrediction,
                        ["Camera"] = TargetedPlayerAimPart.Position + VelocityPrediction
                    }
                elseif not Silent.Settings.Prediction.Toggled then
                    RemoteArguments[3] = {
                        ["MousePos"] = TargetedPlayerAimPart.Position,
                        ["Camera"] = TargetedPlayerAimPart.Position
                    }
                end
            end
            
        elseif (RemoteArguments[2] == "UpdateMousePos" and type(RemoteArguments[3]) == "table" and not RemoteArguments[3]["MousePos"] and not RemoteArguments[3]["Camera"] and RemoteArguments[3][1] and RemoteArguments[3][2]) then
            
            if Hit_Success then
                if Silent.Settings.Prediction.Toggled then
                    RemoteArguments[3] = {
                        [1] = TargetedPlayerAimPart.Position + VelocityPrediction,
                        [2] = TargetedPlayerAimPart.Position + VelocityPrediction
                    }
                elseif not Silent.Settings.Prediction.Toggled then
                    RemoteArguments[3] = {
                        [1] = TargetedPlayerAimPart.Position,
                        [2] = TargetedPlayerAimPart.Position
                    }
                end
            end
            
        end
        
        return OldRawMetaTable(unpack(RemoteArguments))
    end
    return OldRawMetaTable(...)
end)