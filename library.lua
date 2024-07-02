local library = {}

-- Define basic library properties
library.version = "1.0"
library.rank = "FREE VIP  🟢 "
library.fps = 60

-- Define a function to get the username
function library:GetUsername()
    return "Username"
end

-- Define a function to create a watermark
function library:Watermark(text)
    local watermark = {}
    watermark.text = text
    
    function watermark:AddWatermark(text)
        local wm = {}
        wm.text = text
        
        function wm:Text(newText)
            wm.text = newText
        end
        
        return wm
    end
    
    return watermark
end

-- Define a function to initialize notifications
function library:InitNotifications()
    local notifications = {}
    
    function notifications:Notify(text, duration, type)
        print("Notification: " .. text .. " (" .. type .. ")")
    end
    
    return notifications
end

-- Define a function to show introduction
function library:Introduction()
    print("Welcome to BLUENIGHT HUB!")
end

-- Define a function to initialize the library
function library:Init()
    local init = {}
    
    function init:NewTab(name)
        local tab = {}
        tab.name = name
        
        function tab:NewSection(name)
            local section = {}
            section.name = name
            
            function section:NewToggle(name, default, callback)
                local toggle = {}
                toggle.name = name
                toggle.state = default
                
                function toggle:AddKeybind(key)
                    print("Keybind added: " .. key.Name)
                end
                
                return toggle
            end
            
            function section:NewLabel(name, alignment)
                print("Label created: " .. name .. " (" .. alignment .. ")")
            end
            
            function section:NewButton(name, callback)
                print("Button created: " .. name)
            end
            
            function section:NewKeybind(name, key, callback)
                print("Keybind created: " .. name .. " (" .. key.Name .. ")")
            end
            
            function section:NewTextbox(name, default, type, size, multiLine, clearText, callback)
                print("Textbox created: " .. name)
            end
            
            function section:NewSelector(name, default, options, callback)
                print("Selector created: " .. name)
                
                function options:AddOption(option)
                    print("Option added: " .. option)
                end
                
                return options
            end
            
            function section:NewSlider(name, suffix, showValue, range, callback)
                print("Slider created: " .. name)
            end
            
            return section
        end
        
        return tab
    end
    
    return init
end

return library
