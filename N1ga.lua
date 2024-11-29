-- Revised line || modified by sxc_qq1 

local CC = game:GetService("Workspace").CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local enabled = false
local accomidationfactor = 0.131
local Plr
local placemarker = Instance.new("Part", workspace)
placemarker.Anchored = true
placemarker.CanCollide = false
placemarker.Size = Vector3.new(8, 8, 8)
placemarker.Transparency = 0.75

local tool = Instance.new("Tool", LocalPlayer.Backpack)
tool.Name = "NggaLock"
tool.RequiresHandle = false

function makemarker(Parent, Adornee, Color, Size, Size2)
    local e = Instance.new("BillboardGui", Parent)
    e.Name = "PP"
    e.Adornee = Adornee
    e.Size = UDim2.new(Size, Size2, Size, Size2)
    e.AlwaysOnTop = true
    local a = Instance.new("Frame", e)
    a.Size = UDim2.new(1, 0, 1, 0)
    a.BackgroundTransparency = 0
    a.BackgroundColor3 = Color
    local g = Instance.new("UICorner", a)
    g.CornerRadius = UDim.new(50, 50)
    return e
end

function lockOnPlayer(player)
    if enabled and Plr == player then
        enabled = false
        placemarker.CFrame = CFrame.new(0, 9999, 0)
    elseif player then
        enabled = true
        Plr = player
    else
        enabled = false
        placemarker.CFrame = CFrame.new(0, 9999, 0)
    end
end

tool.Activated:Connect(function()
    local target = mouse.Target
    local targetPlayer = target and target.Parent and Players:GetPlayerFromCharacter(target.Parent)
    lockOnPlayer(targetPlayer)
end)

RunService.Stepped:Connect(function()
    if enabled and Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        placemarker.CFrame = CFrame.new(Plr.Character.HumanoidRootPart.Position + (Plr.Character.HumanoidRootPart.Velocity * accomidationfactor))
    else
        placemarker.CFrame = CFrame.new(0, 9999, 0)
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = { ... }
    if enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Plr.Character.HumanoidRootPart.Position + (Plr.Character.HumanoidRootPart.Velocity * accomidationfactor)
        return old(unpack(args))
    end
    return old(...)
end)

LocalPlayer.CharacterAdded:Connect(function()
    tool.Parent = LocalPlayer.Backpack
end)
