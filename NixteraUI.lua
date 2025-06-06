-- NixteraUI v1.0
local NixteraUI = {}
NixteraUI.__index = NixteraUI

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local DEFAULT_CONFIG = {
    PrimaryColor = Color3.fromRGB(100, 70, 200),
    SecondaryColor = Color3.fromRGB(40, 40, 50),
    TextColor = Color3.fromRGB(240, 240, 240),
    DisabledColor = Color3.fromRGB(100, 100, 100),
    Font = Enum.Font.GothamSemibold,
    CornerRadius = UDim.new(0, 8),
    DropShadow = true,
    AnimationSpeed = 0.15,
    Theme = "Dark"
}

function NixteraUI.new(parent, config)
    local self = setmetatable({}, NixteraUI)
    
    self.Config = setmetatable(config or {}, {__index = DEFAULT_CONFIG})
    self.Parent = parent or game:GetService("CoreGui")
    self.Elements = {}
    self.Windows = {}
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NixteraUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.Parent = self.Parent
    
    self.Themes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 35),
            Card = Color3.fromRGB(40, 40, 50),
            Text = Color3.fromRGB(240, 240, 240),
            Border = Color3.fromRGB(60, 60, 70)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            Card = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(30, 30, 30),
            Border = Color3.fromRGB(200, 200, 200)
        }
    }
    
    return self
end

function NixteraUI:CreateWindow(options)
    options = options or {}
    
    local window = {
        Title = options.Title or "Nixtera UI",
        Size = options.Size or UDim2.fromOffset(500, 600),
        Position = options.Position or UDim2.fromOffset(100, 100),
        Tabs = {},
        ActiveTab = nil,
        Minimized = false,
        Visible = true
    }
    
    local windowFrame = Instance.new("Frame")
    windowFrame.Name = "Window"
    windowFrame.Size = window.Size
    windowFrame.Position = window.Position
    windowFrame.BackgroundColor3 = self.Themes[self.Config.Theme].Card
    windowFrame.BorderSizePixel = 0
    windowFrame.ClipsDescendants = true
    windowFrame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Config.CornerRadius
    corner.Parent = windowFrame
    
    if self.Config.DropShadow then
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = 0.8
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0, -5, 0, -5)
        shadow.BackgroundTransparency = 1
        shadow.ZIndex = -1
        shadow.Parent = windowFrame
    end
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = self.Config.PrimaryColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = windowFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Text = window.Title
    titleText.Font = self.Config.Font
    titleText.TextColor3 = self.Config.TextColor
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = self.Config.TextColor
    closeButton.TextSize = 24
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Parent = titleBar
    
    closeButton.MouseButton1Click:Connect(function()
        window.Visible = false
        windowFrame.Visible = false
    end)
    
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 30)
    tabBar.BackgroundColor3 = self.Themes[self.Config.Theme].Card
    tabBar.BorderSizePixel = 0
    tabBar.Parent = windowFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, -70) 
    contentFrame.Position = UDim2.new(0, 0, 0, 70)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = windowFrame
    
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(1, -20, 1, 0)
    tabsContainer.Position = UDim2.new(0, 10, 0, 0)
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.Parent = tabBar
    
    function window:CreateTab(name, icon)
        local tab = {
            Name = name,
            Icon = icon,
            Content = Instance.new("Frame"),
            Button = Instance.new("TextButton"),
            Sections = {}
        }
        
        tab.Content.Name = name .. "Content"
        tab.Content.Size = UDim2.new(1, 0, 1, 0)
        tab.Content.Position = UDim2.new(0, 0, 0, 0)
        tab.Content.BackgroundTransparency = 1
        tab.Content.Visible = false
        tab.Content.Parent = contentFrame
        
        tab.Button.Name = name .. "Tab"
        tab.Button.Text = name
        tab.Button.Font = self.Config.Font
        tab.Button.TextColor3 = self.Config.TextColor
        tab.Button.TextSize = 14
        tab.Button.Size = UDim2.new(0, 100, 1, 0)
        tab.Button.Position = UDim2.new(0, (#window.Tabs * 110), 0, 0)
        tab.Button.BackgroundColor3 = self.Themes[self.Config.Theme].Card
        tab.Button.BorderSizePixel = 0
        tab.Button.AutoButtonColor = false
        tab.Button.Parent = tabsContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tab.Button
        
        tab.Button.MouseButton1Click:Connect(function()
            window:SetActiveTab(tab)
        end)
        
        function tab:CreateSection(title)
            local section = {
                Title = title,
                Frame = Instance.new("Frame"),
                Elements = {}
            }
            
            section.Frame.Name = title .. "Section"
            section.Frame.Size = UDim2.new(1, -20, 0, 0)
            section.Frame.AutomaticSize = Enum.AutomaticSize.Y
            section.Frame.Position = UDim2.new(0, 10, 0, (#tab.Sections * 10 + (#tab.Sections * 150))
            section.Frame.BackgroundColor3 = self.Themes[self.Config.Theme].Card
            section.Frame.BorderSizePixel = 0
            section.Frame.Parent = tab.Content
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = self.Config.CornerRadius
            corner.Parent = section.Frame
            
            local header = Instance.new("Frame")
            header.Name = "Header"
            header.Size = UDim2.new(1, 0, 0, 30)
            header.BackgroundTransparency = 1
            header.Parent = section.Frame
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Name = "Title"
            titleLabel.Text = "  " .. title
            titleLabel.Font = self.Config.Font
            titleLabel.TextColor3 = self.Config.TextColor
            titleLabel.TextSize = 16
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.BackgroundTransparency = 1
            titleLabel.Size = UDim2.new(1, 0, 1, 0)
            titleLabel.Parent = header
            
            local content = Instance.new("Frame")
            content.Name = "Content"
            content.Size = UDim2.new(1, -10, 0, 0)
            content.Position = UDim2.new(0, 5, 0, 35)
            content.AutomaticSize = Enum.AutomaticSize.Y
            content.BackgroundTransparency = 1
            content.Parent = section.Frame
            
            function section:AddButton(params)
                return self:AddElement("Button", params)
            end
            
            function section:AddToggle(params)
                return self:AddElement("Toggle", params)
            end
            
            function section:AddElement(type, params)
                local element
                
                if type == "Button" then
                    element = self:CreateButton(params)
                elseif type == "Toggle" then
                    element = self:CreateToggle(params)
                end
                
                table.insert(section.Elements, element)
                return element
            end
            
            function section:CreateButton(params)
                return NixteraUI:CreateButton(content, params)
            end
            
            function section:CreateToggle(params)
                return NixteraUI:CreateToggle(content, params)
            end
            
            table.insert(tab.Sections, section)
            return section
        end
        
        table.insert(window.Tabs, tab)
        
        if #window.Tabs == 1 then
            window:SetActiveTab(tab)
        end
        
        return tab
    end
    
    function window:SetActiveTab(tab)
        if window.ActiveTab then
            window.ActiveTab.Content.Visible = false
            window.ActiveTab.Button.BackgroundColor3 = self.Themes[self.Config.Theme].Card
        end
        
        window.ActiveTab = tab
        tab.Content.Visible = true
        tab.Button.BackgroundColor3 = self.Config.PrimaryColor
    end
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = windowFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            windowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    table.insert(self.Windows, window)
    self.Elements[windowFrame] = window
    
    return window
end

function NixteraUI:CreateButton(parent, config)
    config = config or {}
    
    local button = {
        Text = config.Text or "Button",
        Callback = config.Callback or function() end,
        Enabled = config.Enabled ~= false
    }
    
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Name = "Button"
    buttonFrame.Text = button.Text
    buttonFrame.Font = self.Config.Font
    buttonFrame.TextColor3 = self.Config.TextColor
    buttonFrame.TextSize = 14
    buttonFrame.Size = config.Size or UDim2.new(1, 0, 0, 36)
    buttonFrame.Position = config.Position or UDim2.new(0, 0, 0, (#parent:GetChildren() * 40))
    buttonFrame.BackgroundColor3 = button.Enabled and self.Config.PrimaryColor or self.Config.DisabledColor
    buttonFrame.BorderSizePixel = 0
    buttonFrame.AutoButtonColor = button.Enabled
    buttonFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = self.Config.CornerRadius
    corner.Parent = buttonFrame
    
    buttonFrame.MouseEnter:Connect(function()
        if button.Enabled then
            TweenService:Create(buttonFrame, TweenInfo.new(self.Config.AnimationSpeed), {
                BackgroundColor3 = Color3.fromRGB(
                    math.floor(self.Config.PrimaryColor.R * 255 * 0.9),
                    math.floor(self.Config.PrimaryColor.G * 255 * 0.9),
                    math.floor(self.Config.PrimaryColor.B * 255 * 0.9)
                )
            }):Play()
        end
    end)
    
    buttonFrame.MouseLeave:Connect(function()
        if button.Enabled then
            TweenService:Create(buttonFrame, TweenInfo.new(self.Config.AnimationSpeed), {
                BackgroundColor3 = self.Config.PrimaryColor
            }):Play()
        end
    end)
    
    buttonFrame.MouseButton1Click:Connect(function()
        if button.Enabled then
            button.Callback()
        end
    end)
    
    function button:SetEnabled(state)
        button.Enabled = state
        buttonFrame.AutoButtonColor = state
        buttonFrame.BackgroundColor3 = state and self.Config.PrimaryColor or self.Config.DisabledColor
    end
    
    function button:SetText(text)
        button.Text = text
        buttonFrame.Text = text
    end
    
    self.Elements[buttonFrame] = button
    return button
end

function NixteraUI:CreateToggle(parent, config)
    config = config or {}
    
    local toggle = {
        Text = config.Text or "Toggle",
        Value = config.Default or false,
        Callback = config.Callback or function() end
    }
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Size = config.Size or UDim2.new(1, 0, 0, 30)
    toggleFrame.Position = config.Position or UDim2.new(0, 0, 0, (#parent:GetChildren() * 40))
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Text = toggle.Text
    label.Font = self.Config.Font
    label.TextColor3 = self.Config.TextColor
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -5, 0.5, -10)
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = toggle.Value and self.Config.PrimaryColor or Color3.fromRGB(100, 100, 100)
    toggleButton.BorderSizePixel = 0
    toggleButton.AutoButtonColor = false
    toggleButton.Parent = toggleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleButton
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "Knob"
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)
    toggleKnob.Position = toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Parent = toggleButton
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = toggleKnob
    
    local function updateToggle()
        TweenService:Create(toggleButton, TweenInfo.new(self.Config.AnimationSpeed), {
            BackgroundColor3 = toggle.Value and self.Config.PrimaryColor or Color3.fromRGB(100, 100, 100)
        }):Play()
        
        TweenService:Create(toggleKnob, TweenInfo.new(self.Config.AnimationSpeed), {
            Position = toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        updateToggle()
        toggle.Callback(toggle.Value)
    end)
    
    function toggle:SetValue(value)
        toggle.Value = value
        updateToggle()
    end
    
    self.Elements[toggleFrame] = toggle
    return toggle
end

return function(parent, config)
    return NixteraUI.new(parent, config)
end
