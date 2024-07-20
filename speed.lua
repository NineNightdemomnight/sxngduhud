-- LocalScript ใน StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local speedBoostEnabled = false
local normalWalkSpeed = 16 -- ความเร็วเดินปกติ
local boostedWalkSpeed = 32 -- ความเร็วที่เพิ่มขึ้น

-- ฟังก์ชันในการเปลี่ยนความเร็วในการเดิน
local function setWalkSpeed(speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

-- ฟังก์ชันในการสลับสถานะของ Speed Boost
local function toggleSpeedBoost()
    speedBoostEnabled = not speedBoostEnabled
    if speedBoostEnabled then
        setWalkSpeed(boostedWalkSpeed)
    else
        setWalkSpeed(normalWalkSpeed)
    end
end

-- เรียกใช้เมื่อ Player เข้ามาในเกมหรือ respawn
player.CharacterAdded:Connect(function(character)
    repeat wait() until character:FindFirstChild("Humanoid")
    setWalkSpeed(speedBoostEnabled and boostedWalkSpeed or normalWalkSpeed)
end)

-- ตรวจจับการกดปุ่ม Shift เพื่อเปิด/ปิด Speed Boost
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftShift then
        toggleSpeedBoost()
    end
end)
