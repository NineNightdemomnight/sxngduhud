local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local TargetPlayer = nil
local LockOn = false

-- สร้าง UI สำหรับเลือกผู้เล่น
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local scrollingFrame = Instance.new("ScrollingFrame", screenGui)
scrollingFrame.Size = UDim2.new(0.2, 0, 0.5, 0)
scrollingFrame.Position = UDim2.new(0.8, 0, 0.25, 0)
scrollingFrame.BackgroundTransparency = 0.5
scrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0) -- ปรับขนาดของ canvas เพื่อให้มีพื้นที่สำหรับสไลด์
scrollingFrame.ScrollBarThickness = 10
scrollingFrame.BackgroundColor3 = Color3.fromRGB(173, 216, 230) -- สีน้ำเงินอ่อน

-- เพิ่มกรอบสีน้ำเงินอ่อน
local uiCorner = Instance.new("UICorner", scrollingFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- ฟังก์ชันเพื่อสร้างปุ่มชื่อผู้เล่น
local function createPlayerButton(player)
    local button = Instance.new("TextButton", scrollingFrame)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, (#scrollingFrame:GetChildren() - 1) * 35)
    button.Text = player.Name
    button.BackgroundColor3 = Color3.fromRGB(173, 216, 230) -- สีน้ำเงินอ่อน
    button.BorderSizePixel = 0

    local uiCorner = Instance.new("UICorner", button)
    uiCorner.CornerRadius = UDim.new(0, 10)

    button.MouseButton1Click:Connect(function()
        if TargetPlayer == player and LockOn then
            -- ถ้ากำลังล็อกผู้เล่นคนนี้อยู่ ให้หยุดการล็อก
            LockOn = false
            TargetPlayer = nil
        else
            -- ถ้ายังไม่ได้ล็อกผู้เล่นคนนี้ ให้ล็อก
            TargetPlayer = player
            LockOn = true
        end
    end)
end

-- ฟังก์ชันเพื่ออัพเดตการล็อกหัวผู้เล่น
local function updateLockOn()
    if LockOn and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
        local head = TargetPlayer.Character.Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
    end
end

-- ฟังก์ชันเพื่อตรวจจับการกดปุ่ม Ctrl+M เพื่อซ่อนหรือแสดง UI
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end

    if input.KeyCode == Enum.KeyCode.M and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        scrollingFrame.Visible = not scrollingFrame.Visible
    end
end)

-- สร้างปุ่มสำหรับผู้เล่นทุกคนในเซิร์ฟเวอร์
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createPlayerButton(player)
    end
end

-- อัพเดตรายชื่อผู้เล่นเมื่อมีผู้เล่นใหม่เข้ามา
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createPlayerButton(player)
    end
end)

-- อัพเดตการล็อกหัวทุกๆ Frame
game:GetService("RunService").RenderStepped:Connect(updateLockOn)
