-- NixteraUI v1.0
local NixteraUI = {}
NixteraUI.__index = NixteraUI

local defaults = {
    PrimaryColor = Color3.fromRGB(100, 70, 200),
    SecondaryColor = Color3.fromRGB(40, 40, 50),
    TextColor = Color3.fromRGB(240, 240, 240),
    AccentColor = Color3.fromRGB(80, 180, 120),
    Font = Enum.Font.GothamSemibold,
    CornerRadius = UDim.new(0, 8),
    DropShadow = true,
    Animations = true,
    SmoothDragging = true
}

function NixteraUI.new(options)
    local self = setmetatable({}, BeautifulUI)
    self.settings = setmetatable(options or {}, {__index = defaults})
    self.windows = {}
    self.notifications = {}
    return self
end

function NixteraUI:CreateWindow(config)
    local window = {
        Title = config.Title or "Beautiful UI",
        Size = config.Size or Vector2.new(500, 600),
        Position = config.Position or Vector2.new(100, 100),
        Tabs = {},
        Minimized = false,
        Visible = true
    }
    
    function window:CreateTab(name, icon)
        local tab = {
            Name = name,
            Icon = icon,
            Sections = {}
        }
        
        function tab:CreateSection(title)
            local section = {
                Title = title,
                Elements = {}
            }
            
            function section:AddButton(params)
                local button = {
                    Type = "Button",
                    Text = params.Text,
                    Tooltip = params.Tooltip,
                    Callback = params.Callback,
                    Style = params.Style or "Primary",
                    Icon = params.Icon,
                    Size = params.Size or UDim2.new(1, -20, 0, 36)
                }
                table.insert(section.Elements, button)
                return button
            end
            
            function section:AddToggle(params)
                local toggle = {
                    Type = "Toggle",
                    Text = params.Text,
                    Default = params.Default or false,
                    Callback = params.Callback,
                    Style = params.Style or "Switch",
                    Tooltip = params.Tooltip
                }
                table.insert(section.Elements, toggle)
                return toggle
            end
            
            function section:AddSlider(params)
                local slider = {
                    Type = "Slider",
                    Text = params.Text,
                    Min = params.Min or 0,
                    Max = params.Max or 100,
                    Default = params.Default or params.Min,
                    Callback = params.Callback,
                    Decimals = params.Decimals or 0,
                    Suffix = params.Suffix or ""
                }
                table.insert(section.Elements, slider)
                return slider
            end
            
            function section:AddDropdown(params)
                local dropdown = {
                    Type = "Dropdown",
                    Text = params.Text,
                    Options = params.Options or {},
                    Default = params.Default,
                    MultiSelect = params.MultiSelect or false,
                    Callback = params.Callback,
                    Searchable = params.Searchable or false
                }
                table.insert(section.Elements, dropdown)
                return dropdown
            end
            
            function section:AddInput(params)
                local input = {
                    Type = "Input",
                    Text = params.Text,
                    Placeholder = params.Placeholder or "",
                    Default = params.Default or "",
                    Callback = params.Callback,
                    Numeric = params.Numeric or false,
                    ClearTextOnFocus = params.ClearTextOnFocus or false
                }
                table.insert(section.Elements, input)
                return input
            end
            
            function section:AddLabel(params)
                local label = {
                    Type = "Label",
                    Text = params.Text,
                    Style = params.Style or "Normal",
                    TextSize = params.TextSize or 14,
                    TextColor = params.TextColor
                }
                table.insert(section.Elements, label)
                return label
            end
            
            table.insert(tab.Sections, section)
            return section
        end
        
        table.insert(window.Tabs, tab)
        return tab
    end
    
    function window:Minimize()
        window.Minimized = not window.Minimized
        
    end
    
    function window:Close()
        window.Visible = false
        
    end
    
    table.insert(self.windows, window)
    return window
end

function NixteraUI:Notify(params)
    local notification = {
        Title = params.Title or "Notification",
        Content = params.Content or "",
        Duration = params.Duration or 5,
        Type = params.Type or "Info",
        Callback = params.Callback
    }
    
    table.insert(self.notifications, notification)
    
    task.spawn(function()
        task.wait(notification.Duration)
    end)
    
    return notification
end

return NixteraUI.new()
