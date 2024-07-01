local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local guiVisible = true  -- ตัวแปรเพื่อตรวจสอบสถานะการแสดงผลของ GUI

-- ฟังก์ชันในการสร้าง BillboardGui
local function createBillboardGui(targetPlayer)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerInfoGui"
    billboardGui.Adornee = targetPlayer.Character:FindFirstChild("Head")
    billboardGui.Parent = targetPlayer.Character
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)  -- ตำแหน่ง GUI บนหัวของผู้เล่น
    billboardGui.AlwaysOnTop = true
    billboardGui.MaxDistance = 1000  -- ขนาดที่ซ่อน GUI เมื่อผู้เล่นห่างออกไป
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboardGui

    -- เพิ่ม UIStroke เพื่อสร้างขอบ
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(0, 0, 0)
    uiStroke.Thickness = 2
    uiStroke.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.Parent = frame
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.3, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.4, 0)
    healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    healthLabel.TextScaled = true
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "HP: "
    healthLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.7, 0)
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextScaled = true
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "Distance: "
    distanceLabel.Parent = frame

    -- อัพเดตข้อมูล
    RunService.Heartbeat:Connect(function()
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).magnitude
            local health = targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health
            local maxHealth = targetPlayer.Character:FindFirstChildOfClass("Humanoid").MaxHealth
            
            healthLabel.Text = string.format("HP: %d/%d", health, maxHealth)
            distanceLabel.Text = string.format("Distance: %.2f", distance)
        end
    end)
end

-- ฟังก์ชันเพื่อเปิด/ปิดการแสดงผลของ GUI
local function toggleGuiVisibility()
    guiVisible = not guiVisible
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local billboardGui = targetPlayer.Character:FindFirstChild("PlayerInfoGui")
            if billboardGui then
                billboardGui.Enabled = guiVisible
            end
        end
    end
end

-- สร้าง BillboardGui สำหรับผู้เล่นที่มีอยู่แล้ว
for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        createBillboardGui(targetPlayer)
    end
end

-- สร้าง BillboardGui สำหรับผู้เล่นใหม่ที่เข้ามาในเกม
Players.PlayerAdded:Connect(function(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function()
        if targetPlayer.Character:FindFirstChild("Head") then
            createBillboardGui(targetPlayer)
        end
    end)
end)

-- ลบ BillboardGui สำหรับผู้เล่นที่ออกจากเกม
Players.PlayerRemoving:Connect(function(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local billboardGui = targetPlayer.Character:FindFirstChild("PlayerInfoGui")
        if billboardGui then
            billboardGui:Destroy()
        end
    end
end)

-- ตรวจจับการกดแป้นพิมพ์ Ctrl + B เพื่อเปิด/ปิด GUI
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.B and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            toggleGuiVisibility()
        end
    end
end)
