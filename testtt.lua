_G.PART = "HumanoidRootPart"
_G.PRED = 0.13960
_G.T = 0.7

local lp = game:GetService("Players").LocalPlayer
local mouse = lp:GetMouse()
local enabled = false
local Target
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = { ... }
    if enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Target[_G.PART].Position + (Target[_G.PART].Velocity * _G.PRED)
        return old(unpack(args))
    end
    return old(...)
end)

local MyAss = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

MyAss.Name = "MyAss"
MyAss.Parent = game.CoreGui

Frame.Parent = MyAss
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.5, -100, 0.5, -40)
Frame.Size = UDim2.new(0, 200, 0, 80)
Frame.Active = true
Frame.Draggable = true

UICorner.Parent = Frame

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TextButton.Position = UDim2.new(0.05, 0, 0.2, 0)
TextButton.Size = UDim2.new(0.9, 0, 0.6, 0)
TextButton.Font = Enum.Font.GothamSemibold
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 16
TextButton.Text = "lock {off}"

UICorner_2.Parent = TextButton

TextButton.MouseButton1Click:Connect(function()
    if enabled then
        enabled = false
        TextButton.Text = "lock {off}"
    else
        enabled = true
        TextButton.Text = "lock {on}"
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= lp and v.Character.BodyEffects:FindFirstChild("K.O").Value == false then
            if mouse.Target == v.Character.HumanoidRootPart then
                Target = v.Character
            end
        end
        if v ~= lp then
            if v.Character.BodyEffects:FindFirstChild("K.O").Value == false then
                v.Character.HumanoidRootPart.Size = Vector3.new(20, 20, 20)
                v.Character.HumanoidRootPart.Transparency = _G.T
                v.Character.HumanoidRootPart.CanCollide = false
            else
                v.Character.HumanoidRootPart.Size = Vector3.new(0.1, 0.1, 0.1)
                v.Character.HumanoidRootPart.Transparency = 1
                v.Character.HumanoidRootPart.CanCollide = false
            end
            if v.Character:FindFirstChild("GRABBING_CONSTRAINT") then
                v.Character.HumanoidRootPart.Size = Vector3.new(0.1, 0.1, 0.1)
                v.Character.HumanoidRootPart.Transparency = 1
                v.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

