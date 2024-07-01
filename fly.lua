-- Fly Script
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local flying = false
local speed = 50 -- เปลี่ยนค่าความเร็วที่ต้องการ

local function fly()
    if flying then return end
    flying = true

    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = humanoidRootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.Parent = humanoidRootPart

    local function moveFly()
        local direction = (mouse.Hit.p - humanoidRootPart.Position).unit
        bodyVelocity.Velocity = direction * speed
        bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position, mouse.Hit.p)
    end

    mouse.Move:Connect(moveFly)

    while flying do
        wait()
    end

    bodyVelocity:Destroy()
    bodyGyro:Destroy()
end

local function stopFly()
    flying = false
end

-- กดปุ่ม "F" เพื่อเริ่มหรือหยุดโหมด Fly
mouse.KeyDown:Connect(function(key)
    if key == "f" then
        if flying then
            stopFly()
        else
            fly()
        end
    end
end)
