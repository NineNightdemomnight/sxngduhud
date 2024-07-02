-- KavoLibrary.lua
local Library = {}

-- สร้าง Window ใหม่
function Library.CreateWindow(options)
    local Window = Instance.new("ScreenGui")
    Window.Name = options.Name
    Window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    Window.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = options.Size
    MainFrame.Position = UDim2.new(0.5, -options.Size.X.Offset / 2, 0.5, -options.Size.Y.Offset / 2)
    MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MainFrame.Parent = Window

    -- ฟังก์ชันสำหรับสร้าง Tab
    function Window:NewTab(name)
        local Tab = Instance.new("Frame")
        Tab.Name = name
        Tab.Parent = MainFrame
        Tab.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        Tab.Size = UDim2.new(1, 0, 1, 0)
        Tab.Visible = true
        
        -- ฟังก์ชันสำหรับสร้าง Section
        function Tab:NewSection(name)
            local Section = Instance.new("Frame")
            Section.Name = name
            Section.Parent = Tab
            Section.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            Section.Size = UDim2.new(1, 0, 0, 200)

            -- ฟังก์ชันสำหรับสร้าง Button
            function Section:NewButton(text, description, callback)
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0, 280, 0, 50)
                Button.Position = UDim2.new(0, 10, 0, 10 + (#Section:GetChildren() - 1) * 60)
                Button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                Button.Text = text
                Button.TextColor3 = Color3.new(1, 1, 1)
                Button.Parent = Section
                Button.MouseButton1Click:Connect(callback)
            end

            -- ฟังก์ชันสำหรับสร้าง Toggle
            function Section:NewToggle(text, default, callback)
                local Toggle = Instance.new("TextButton")
                Toggle.Size = UDim2.new(0, 280, 0, 50)
                Toggle.Position = UDim2.new(0, 10, 0, 10 + (#Section:GetChildren() - 1) * 60)
                Toggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                Toggle.Text = text
                Toggle.TextColor3 = Color3.new(1, 1, 1)
                Toggle.Parent = Section
                Toggle.MouseButton1Click:Connect(function()
                    default = not default
                    callback(default)
                end)
            end

            -- ฟังก์ชันสำหรับสร้าง Slider
            function Section:NewSlider(text, description, min, max, default, callback)
                local Slider = Instance.new("Frame")
                Slider.Size = UDim2.new(0, 280, 0, 50)
                Slider.Position = UDim2.new(0, 10, 0, 10 + (#Section:GetChildren() - 1) * 60)
                Slider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
                Slider.Parent = Section
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, 0, 0, 10)
                SliderBar.Position = UDim2.new(0, 0, 0, 20)
                SliderBar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                SliderBar.Parent = Slider
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
                SliderFill.Parent = SliderBar
                
                -- สร้าง Slider GUI และการทำงานของมัน
                Slider.MouseButton1Click:Connect(function()
                    local value = min + (max - min) * (SliderBar.Size.X.Scale)
                    callback(value)
                end)
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Library
