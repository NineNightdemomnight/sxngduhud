local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local connections = {}
local ESPEnabled = false  -- สถานะการเปิด/ปิด ESP

-- ฟังก์ชันเพื่อสร้างเส้นเชื่อมต่อ
local function createConnectionLine(targetPlayer)
    if connections[targetPlayer.UserId] then
        return
    end

    local character = targetPlayer.Character
    if not character then
        return
    end

    local startPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local endPart = character:FindFirstChild("HumanoidRootPart")

    if not startPart or not endPart then
        return
    end

    -- สร้างเส้น
    local attachment0 = Instance.new("Attachment")
    attachment0.Parent = startPart

    local attachment1 = Instance.new("Attachment")
    attachment1.Parent = endPart

    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.FaceCamera = true
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))  -- สีของเส้น
    beam.Width0 = 0.1  -- ความกว้างของเส้นต้น
    beam.Width1 = 0.1  -- ความกว้างของเส้นปลาย
    beam.Parent = startPart

    -- เก็บข้อมูลเส้นเชื่อมต่อในตาราง
    connections[targetPlayer.UserId] = {beam, attachment0, attachment1}
end

-- ฟังก์ชันเพื่อลบเส้นเชื่อมต่อ
local function removeConnectionLine(targetPlayer)
    if connections[targetPlayer.UserId] then
        connections[targetPlayer.UserId][1]:Destroy()
        connections[targetPlayer.UserId][2]:Destroy()
        connections[targetPlayer.UserId][3]:Destroy()
        connections[targetPlayer.UserId] = nil
    end
end

-- ฟังก์ชันเพื่อตรวจสอบและอัพเดตเส้นเชื่อมต่อ
local function updateConnections()
    if ESPEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not connections[p.UserId] then
                    createConnectionLine(p)
                end
            elseif connections[p.UserId] then
                removeConnectionLine(p)
            end
        end
    else
        -- ลบเส้นเชื่อมต่อทั้งหมดเมื่อ ESP ถูกปิด
        for _, connection in pairs(connections) do
            connection[1]:Destroy()
            connection[2]:Destroy()
            connection[3]:Destroy()
        end
        connections = {}
    end
end

-- อัพเดตเส้นเชื่อมต่อทุกๆ 0.1 วินาที
RunService.RenderStepped:Connect(updateConnections)

-- ฟังก์ชันเพื่อตรวจจับการกดปุ่ม Ctrl+L
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end

    if input.KeyCode == Enum.KeyCode.L and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        ESPEnabled = not ESPEnabled
    end
end)
