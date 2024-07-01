local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local TargetPlayer = nil
local LockOn = false

-- ฟังก์ชันเพื่อค้นหาผู้เล่นเป้าหมายจากเมาส์
local function findTargetPlayer()
    local mouse = LocalPlayer:GetMouse()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and mouse.Target then
            if player.Character:FindFirstChild("Head") == mouse.Target then
                return player
            end
        end
    end
    return nil
end

-- ฟังก์ชันเพื่ออัพเดตการล็อกหัวผู้เล่น
local function updateLockOn()
    if LockOn and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
        local head = TargetPlayer.Character.Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
    end
end

-- ฟังก์ชันเพื่อตรวจจับการกดปุ่ม Ctrl+Q
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end

    if input.KeyCode == Enum.KeyCode.Q and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if LockOn then
            LockOn = false
            TargetPlayer = nil
        else
            TargetPlayer = findTargetPlayer()
            if TargetPlayer then
                LockOn = true
            end
        end
    end
end)

-- อัพเดตการล็อกหัวทุกๆ Frame
game:GetService("RunService").RenderStepped:Connect(updateLockOn)
