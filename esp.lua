local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local highlightTemplate = Instance.new("Highlight")
highlightTemplate.Name = "Highlight"
highlightTemplate.OutlineColor = Color3.fromRGB(255, 0, 0)  -- สีของกรอบ Highlight
highlightTemplate.OutlineTransparency = 0  -- ความโปร่งใสของกรอบ Highlight (0 = ไม่โปร่งใสเลย)
highlightTemplate.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  -- ทำให้ Highlight อยู่ด้านบนสุด
highlightTemplate.FillColor = Color3.fromRGB(255, 0, 0)  -- สีการเติมของ Highlight
highlightTemplate.FillTransparency = 0.5  -- ความโปร่งใสของการเติม (0 = ไม่โปร่งใสเลย)

local highlightEnabled = true  -- สถานะเปิด/ปิด Highlight

-- ฟังก์ชันในการเพิ่ม Highlight ให้กับตัวละคร
local function addHighlightToCharacter(character)
    if not highlightEnabled then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = highlightTemplate:Clone()
        highlightClone.Adornee = character
        highlightClone.Parent = humanoidRootPart
    end
end

-- ฟังก์ชันในการลบ Highlight จากตัวละคร
local function removeHighlightFromCharacter(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local highlight = humanoidRootPart:FindFirstChild("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- ฟังก์ชันในการสลับสถานะ Highlight
local function toggleHighlight()
    highlightEnabled = not highlightEnabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if highlightEnabled then
                addHighlightToCharacter(player.Character)
            else
                removeHighlightFromCharacter(player.Character)
            end
        end
    end
end

-- เรียกใช้เมื่อ Player เข้ามาในเกม
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        repeat wait() until character:FindFirstChild("HumanoidRootPart")
        addHighlightToCharacter(character)
    end)
end)

-- เรียกใช้เมื่อ Player ออกจากเกม
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeHighlightFromCharacter(player.Character)
    end
end)

-- เพิ่ม Highlight ให้กับ Player ที่มีอยู่แล้วในเกม
for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(character)
        repeat wait() until character:FindFirstChild("HumanoidRootPart")
        addHighlightToCharacter(character)
    end)
    if player.Character then
        addHighlightToCharacter(player.Character)
    end
end

-- อัพเดต Highlight ทุกๆ 0.1 วินาที
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if highlightEnabled and not player.Character.HumanoidRootPart:FindFirstChild("Highlight") then
                addHighlightToCharacter(player.Character)
            elseif not highlightEnabled and player.Character.HumanoidRootPart:FindFirstChild("Highlight") then
                removeHighlightFromCharacter(player.Character)
            end
        end
    end
end)

-- ตรวจจับการกดปุ่ม Ctrl+H
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end

    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleHighlight()
    end
end)
