local StarterGui = game:GetService("StarterGui")
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jxereas/UI-Libraries/main/notification_gui_library.lua", true))()

Notification.new("info", "LoadTime", "[0.20382s]")
StarterGui:SetCore("SendNotification", {
    Title = "",
    Text = "[LoadTime: 0.20382s] GUI Loaded",
    Duration = 10
})

print("[LoadTime: 0.20382s] GUI Loaded.")
print("[Type: Health]:ConnectedHumanoid_Health.100")
local gui = Instance.new("ScreenGui")
gui.Name = "CeX Panel"
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local guiName = Instance.new("TextLabel")
guiName.Size = UDim2.new(1, 0, 0, 20)
guiName.Position = UDim2.new(0, 0, 0, 0)
guiName.BackgroundTransparency = 1
guiName.TextColor3 = Color3.new(1, 1, 1)
guiName.Text = "CeX Panel"
guiName.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 100, 0, 20)
statusText.Position = UDim2.new(0, 0, 0, 20)
statusText.BackgroundTransparency = 1
statusText.TextColor3 = Color3.new(1, 1, 1)
statusText.Text = "Status Player:"
statusText.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 50)
toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "Killable Character"
toggleButton.Parent = frame

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0, 180, 0, 30)
executeButton.Position = UDim2.new(0, 10, 0, 90)
executeButton.BackgroundColor3 = Color3.new(1, 0, 0)
executeButton.TextColor3 = Color3.new(1, 1, 1)
executeButton.Text = "Advanced Unkillable"
executeButton.Parent = frame

local minimizerButton = Instance.new("TextButton")
minimizerButton.Size = UDim2.new(0, 20, 0, 20)
minimizerButton.Position = UDim2.new(1, -20, 0, 0)
minimizerButton.BackgroundColor3 = Color3.new(0, 0, 0)
minimizerButton.TextColor3 = Color3.new(1, 1, 1)
minimizerButton.Text = "-"
minimizerButton.Parent = frame

local minimizedBox = Instance.new("TextButton")
minimizedBox.Size = UDim2.new(0, 30, 0, 30)
minimizedBox.Position = frame.Position
minimizedBox.BackgroundColor3 = Color3.new(0, 0, 0)
minimizedBox.TextColor3 = Color3.new(1, 1, 1)
minimizedBox.Text = "CeX"
minimizedBox.Visible = false
minimizedBox.Active = true
minimizedBox.Draggable = true
minimizedBox.Parent = gui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
statusLabel.BackgroundTransparency = 0.5
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Text = "github.com/vzexg-2"
statusLabel.Parent = frame
getgenv().God = false

local function onDamageTaken()
    if getgenv().God then
        local player = game:GetService("Players").LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 100
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end
    end
end

local function toggleGodMode()
    getgenv().God = not getgenv().God

    if getgenv().God then
        toggleButton.Text = "Unkillable Character"
        toggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
        local player = game:GetService("Players").LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:GetPropertyChangedSignal("Health"):Connect(onDamageTaken)
            humanoid.HealthChanged:Connect(onDamageTaken)
        end
        spawn(function()
            while getgenv().God do
                wait(0.1)
                onDamageTaken()
            end
        end)
    else
        toggleButton.Text = "Killable Character"
        toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
        local player = game:GetService("Players").LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end
    end
end

toggleButton.MouseButton1Click:Connect(toggleGodMode)

executeButton.MouseButton1Click:Connect(function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:Remove()
            local newHumanoid = Instance.new('Humanoid', character)
            newHumanoid.HipHeight = 2
        end
    end
end)

minimizerButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    minimizedBox.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
    minimizedBox.Visible = true
end)

minimizedBox.MouseButton1Click:Connect(function()
    frame.Visible = true
    minimizedBox.Visible = false
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    frame.Visible = true
end)
setclipboard("CeX Panel using new method instead of the looping humanoid health, it purpose is to prevent user's from dying, it may work in some games like Toh, and other's.")