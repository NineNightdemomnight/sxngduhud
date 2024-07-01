local Players = game:GetService("Players")
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoginScreen"
screenGui.Parent = player.PlayerGui

-- Create the main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.6, 0)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(245, 245, 255)  -- เปลี่ยนเป็นสีฟ้าอ่อน
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add a rounded corner to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Add a background image with anime theme
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Position = UDim2.new(0, 0, 0, 0)
backgroundImage.Image = "rbxassetid://18286971912"  -- เปลี่ยนเป็น ID ของภาพพื้นหลังอนิเมะ
backgroundImage.BackgroundTransparency = 1
backgroundImage.ZIndex = 0  -- ทำให้แน่ใจว่าภาพอยู่ด้านล่าง
backgroundImage.Parent = frame

-- Add an icon to the top of the frame
local iconImage = Instance.new("ImageLabel")
iconImage.Size = UDim2.new(0.2, 0, 0.2, 0)
iconImage.Position = UDim2.new(0.4, 0, 0.05, 0)
iconImage.Image = "rbxassetid://18286971912"  -- เปลี่ยนเป็น ID ของไอคอนอนิเมะ
iconImage.BackgroundTransparency = 1
iconImage.Parent = frame

-- Add a title to the frame
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Login"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0.25, 0)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = frame

-- Create the input box for code
local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(0.8, 0, 0.15, 0)
codeBox.Position = UDim2.new(0.1, 0, 0.4, 0)
codeBox.PlaceholderText = "Enter Password or Key"
codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
codeBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
codeBox.TextScaled = true
codeBox.ClearTextOnFocus = false
codeBox.TextStrokeTransparency = 0.5
codeBox.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
codeBox.Parent = frame

-- Add a rounded corner to the code box
local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 5)
codeCorner.Parent = codeBox

-- Create a frame to hold the buttons
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0.8, 0, 0.2, 0)
buttonContainer.Position = UDim2.new(0.1, 0, 0.7, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

-- Create a layout for the buttons
local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
buttonLayout.Padding = UDim.new(0, 10)
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Parent = buttonContainer

-- Create the submit button
local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.4, 0, 1, 0)  -- Adjusted size for horizontal layout
submitButton.Text = "Login"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- เปลี่ยนเป็นสีเขียวสด
submitButton.TextScaled = true
submitButton.TextStrokeTransparency = 0.5
submitButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
submitButton.Font = Enum.Font.GothamBold
submitButton.LayoutOrder = 1
submitButton.Parent = buttonContainer

-- Add a rounded corner to the submit button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = submitButton

-- Add a border to the submit button
local buttonBorder = Instance.new("Frame")
buttonBorder.Size = UDim2.new(1, 0, 1, 0)
buttonBorder.Position = UDim2.new(0, 0, 0, 0)
buttonBorder.BackgroundTransparency = 1
buttonBorder.BorderSizePixel = 3
buttonBorder.BorderColor3 = Color3.fromRGB(255, 215, 0)  -- เปลี่ยนเป็นสีทอง
buttonBorder.ZIndex = 2  -- ทำให้แน่ใจว่าเส้นขอบอยู่เหนือปุ่ม
buttonBorder.Parent = submitButton

-- Create the link button
local linkButton = Instance.new("TextButton")
linkButton.Size = UDim2.new(0.4, 0, 1, 0)  -- Adjusted size for horizontal layout
linkButton.Text = "Get Discord Link"
linkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
linkButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)  -- เปลี่ยนเป็นสีน้ำเงินสด
linkButton.TextScaled = true
linkButton.TextStrokeTransparency = 0.5
linkButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
linkButton.Font = Enum.Font.GothamBold
linkButton.LayoutOrder = 2
linkButton.Parent = buttonContainer

-- Add a rounded corner to the link button
local linkButtonCorner = Instance.new("UICorner")
linkButtonCorner.CornerRadius = UDim.new(0, 5)
linkButtonCorner.Parent = linkButton

-- Add a border to the link button
local linkButtonBorder = Instance.new("Frame")
linkButtonBorder.Size = UDim2.new(1, 0, 1, 0)
linkButtonBorder.Position = UDim2.new(0, 0, 0, 0)
linkButtonBorder.BackgroundTransparency = 1
linkButtonBorder.BorderSizePixel = 3
linkButtonBorder.BorderColor3 = Color3.fromRGB(255, 215, 0)  -- เปลี่ยนเป็นสีทอง
linkButtonBorder.ZIndex = 2  -- ทำให้แน่ใจว่าเส้นขอบอยู่เหนือปุ่ม
linkButtonBorder.Parent = linkButton

-- Create an error label
local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, 0, 0.1, 0)
errorLabel.Position = UDim2.new(0, 0, 0.95, 0)
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

-- Function to check the code
local function checkCode(code)
    local url = "https://pastebin.com/raw/mnZi5vLZ" -- URL to fetch the raw Pastebin data

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        if response:find(code) then
            -- Successful login
            screenGui:Destroy()
            -- Your code to handle successful login goes here
            print("Login Successful!")

            -- Execute the script from the link
            local scriptUrl = "https://raw.githubusercontent.com/NineNightdemomnight/esp/main/main.lua"
            local success, result = pcall(function()
                loadstring(game:HttpGet(scriptUrl))()
            end)
            if not success then
                warn("Failed to execute the script from the URL: " .. result)
            end
        else
            -- Incorrect code
            errorLabel.Text = "Incorrect Password or Key!"
            errorLabel.Visible = true
        end
    else
        -- Network or other errors
        errorLabel.Text = "Failed to fetch data!"
        errorLabel.Visible = true
    end
end

-- Connect the submit button to the checkCode function
submitButton.MouseButton1Click:Connect(function()
    local code = codeBox.Text
    if code and code ~= "" then
        checkCode(code)
    else
        errorLabel.Text = "Please enter a code!"
        errorLabel.Visible = true
    end
end)

-- Connect the link button to copy the Discord link
linkButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/zxeZfscCmj")
    print("Discord link copied to clipboard!")
end)

-- Connect the close button to destroy the UI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
