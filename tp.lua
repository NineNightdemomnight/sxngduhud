-- LocalScript

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

-- สร้าง GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.Parent = player.PlayerGui

-- สร้างกรอบสำหรับ GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.3, 0)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Teleport to Player"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextStrokeTransparency = 0.7
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Parent = frame

local playerNameInput = Instance.new("TextBox")
playerNameInput.Size = UDim2.new(1, -20, 0.3, 0)
playerNameInput.Position = UDim2.new(0, 10, 0.25, 0)
playerNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameInput.PlaceholderText = "Enter player name"
playerNameInput.TextScaled = true
playerNameInput.Font = Enum.Font.Gotham
playerNameInput.TextStrokeTransparency = 0.7
playerNameInput.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
playerNameInput.Parent = frame

local teleportButton = Instance.new("TextButton")
teleportButton.Text = "Teleport"
teleportButton.Size = UDim2.new(1, -20, 0.3, 0)
teleportButton.Position = UDim2.new(0, 10, 0.6, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextStrokeTransparency = 0.7
teleportButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.Parent = frame

local function teleportToPlayer(name)
    local targetPlayer = game.Players:FindFirstChild(name)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        print("Teleported to " .. name)
    else
        print("Player not found or player has no character.")
    end
end

teleportButton.MouseButton1Click:Connect(function()
    local playerName = playerNameInput.Text
    teleportToPlayer(playerName)
end)

-- ปิด GUI ด้วยปุ่ม X
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.2, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.TextStrokeTransparency = 0.5
closeButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
