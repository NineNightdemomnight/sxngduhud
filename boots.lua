local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoostUI"
screenGui.Parent = player.PlayerGui

-- Create the main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.4, 0)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add a rounded corner to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Add a title to the frame
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Boost Options"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = frame

-- Create the add HP button
local addHPButton = Instance.new("TextButton")
addHPButton.Size = UDim2.new(0.8, 0, 0.2, 0)
addHPButton.Position = UDim2.new(0.1, 0, 0.3, 0)
addHPButton.Text = "Set HP to 1000"
addHPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
addHPButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
addHPButton.TextScaled = true
addHPButton.TextStrokeTransparency = 0.5
addHPButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
addHPButton.Font = Enum.Font.GothamBold
addHPButton.Parent = frame

-- Add a rounded corner to the add HP button
local addHPCorner = Instance.new("UICorner")
addHPCorner.CornerRadius = UDim.new(0, 5)
addHPCorner.Parent = addHPButton

-- Create the add Speed button
local addSpeedButton = Instance.new("TextButton")
addSpeedButton.Size = UDim2.new(0.8, 0, 0.2, 0)
addSpeedButton.Position = UDim2.new(0.1, 0, 0.6, 0)
addSpeedButton.Text = "Set Speed to 50"
addSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
addSpeedButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
addSpeedButton.TextScaled = true
addSpeedButton.TextStrokeTransparency = 0.5
addSpeedButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
addSpeedButton.Font = Enum.Font.GothamBold
addSpeedButton.Parent = frame

-- Add a rounded corner to the add Speed button
local addSpeedCorner = Instance.new("UICorner")
addSpeedCorner.CornerRadius = UDim.new(0, 5)
addSpeedCorner.Parent = addSpeedButton

-- Create an error label
local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, 0, 0.1, 0)
errorLabel.Position = UDim2.new(0, 0, 0.9, 0)
errorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
errorLabel.BackgroundTransparency = 1
errorLabel.TextScaled = true
errorLabel.Visible = false
errorLabel.TextStrokeTransparency = 0.5
errorLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
errorLabel.Font = Enum.Font.GothamBold
errorLabel.Parent = frame

-- Create the close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0.05, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.TextStrokeTransparency = 0.5
closeButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = frame

-- Add a rounded corner to the close button
local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 5)
closeButtonCorner.Parent = closeButton

-- Add functionality to the add HP button
addHPButton.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.Health = 1000  -- Set HP to 1000
        errorLabel.Text = "HP set to 1000!"
        errorLabel.Visible = true
        wait(2)  -- Hide the message after 2 seconds
        errorLabel.Visible = false
    else
        errorLabel.Text = "Humanoid not found!"
        errorLabel.Visible = true
    end
end)

-- Add functionality to the add Speed button
addSpeedButton.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.WalkSpeed = 50  -- Set speed to 50
        errorLabel.Text = "Speed set to 50!"
        errorLabel.Visible = true
        wait(2)  -- Hide the message after 2 seconds
        errorLabel.Visible = false
    else
        errorLabel.Text = "Humanoid not found!"
        errorLabel.Visible = true
    end
end)

-- Add functionality to the close button
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
