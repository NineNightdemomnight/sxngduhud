local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local ESPFrames = {}  -- ตารางเพื่อเก็บ ESP Frames สำหรับผู้เล่นทั้งหมด
local espEnabled = false  -- สถานะเปิด/ปิด ESP

-- ฟังก์ชันเพื่อสร้างกรอบ ESP
local function createESP(targetPlayer)
    if ESPFrames[targetPlayer.UserId] then
        return
    end

    local character = targetPlayer.Character
    if not character then
        return
    end

    -- สร้างกรอบสำหรับตัวละคร
    local espFrame = Instance.new("BoxHandleAdornment")
    espFrame.Name = "ESPFrame"
    espFrame.Parent = character
    espFrame.Adornee = character
    espFrame.Size = Vector3.new(4, 7, 4)  -- ขนาดของกรอบ ESP ปรับตามขนาด Humanoid
    espFrame.Color3 = Color3.fromRGB(255, 0, 0)  -- สีกรอบเป็นสีแดง
    espFrame.Transparency = 0.5  -- ทำให้กรอบมองทะลุได้
    espFrame.ZIndex = 10
    espFrame.AlwaysOnTop = true

    -- เพิ่ม ESP Frame ลงในตาราง ESPFrames
    ESPFrames[targetPlayer.UserId] = {espFrame}
end

-- ฟังก์ชันเพื่ออัพเดต ESP Frames ให้ติดตามผู้เล่น
local function updateESP()
    if not espEnabled then
        for userId, frames in pairs(ESPFrames) do
            if frames[1] then frames[1]:Destroy() end
            ESPFrames[userId] = nil
        end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            if not ESPFrames[p.UserId] then
                createESP(p)
            end
        elseif ESPFrames[p.UserId] then
            ESPFrames[p.UserId][1]:Destroy()
            ESPFrames[p.UserId] = nil
        end
    end
end

-- อัพเดต ESP Frames ทุกๆ 0.1 วินาที
RunService.RenderStepped:Connect(updateESP)

-- ฟังก์ชันเพื่อสลับสถานะ ESP
local function toggleESP()
    espEnabled = not espEnabled
    updateESP()
end

-- ตรวจจับการกดปุ่ม Ctrl+F
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end

    if input.KeyCode == Enum.KeyCode.F and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleESP()
    end
end)