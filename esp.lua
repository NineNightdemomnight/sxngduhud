local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local highlightTemplate = Instance.new("Highlight")
highlightTemplate.Name = "Highlight"
highlightTemplate.OutlineColor = Color3.fromRGB(255, 0, 0)
highlightTemplate.OutlineTransparency = 0
highlightTemplate.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlightTemplate.FillColor = Color3.fromRGB(255, 0, 0)
highlightTemplate.FillTransparency = 0.5

local highlightEnabled = true

local function createBillboardGui()
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(1, 0, 1, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- ตั้งค่าสีเป็นสีแดง
    textLabel.TextScaled = true
    textLabel.Text = "Distance"
    textLabel.Parent = billboardGui
    
    return billboardGui
end

local function addHighlightToCharacter(character)
    if not highlightEnabled then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = highlightTemplate:Clone()
        highlightClone.Adornee = character
        highlightClone.Parent = humanoidRootPart
        
        local billboardGui = createBillboardGui()
        billboardGui.Parent = humanoidRootPart
    end
end

local function removeHighlightFromCharacter(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local highlight = humanoidRootPart:FindFirstChild("Highlight")
        if highlight then
            highlight:Destroy()
        end
        
        local billboardGui = humanoidRootPart:FindFirstChild("BillboardGui")
        if billboardGui then
            billboardGui:Destroy()
        end
    end
end

local function updateDistanceText()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local billboardGui = humanoidRootPart:FindFirstChild("BillboardGui")
            if billboardGui then
                local textLabel = billboardGui:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    local distance = (humanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                    textLabel.Text = string.format("Distance: %.2f", distance)
                    
                    -- ปรับขนาดตามระยะห่าง
                    local size = math.clamp(distance / 10, 0.5, 2) -- ขนาดจะอยู่ระหว่าง 0.5 ถึง 2 เท่าของขนาดปกติ
                    textLabel.TextSize = size * 40 -- ปรับตามความเหมาะสม
                end
            end
        end
    end
end

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

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        repeat wait() until character:FindFirstChild("HumanoidRootPart")
        addHighlightToCharacter(character)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeHighlightFromCharacter(player.Character)
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(character)
        repeat wait() until character:FindFirstChild("HumanoidRootPart")
        addHighlightToCharacter(character)
    end)
    if player.Character then
        addHighlightToCharacter(player.Character)
    end
end

RunService.Heartbeat:Connect(function()
    updateDistanceText()
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

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end

    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleHighlight()
    end
end)
