# NixteraUI - Modern Lua UI Framework
NixteraUI is an elegant and customizable UI framework for Lua (Roblox, FiveM, Love2D, etc.), loadable via loadstring.

📥 Installation
lua
local NixteraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nixtera/NixteraUI/main/source.lua"))()
🎨 Key Features
✅ Customizable (colors, fonts, animations)
✅ Multiple UI Elements (buttons, toggles, sliders, dropdowns)
✅ Dark/Light Themes
✅ Smooth Animations
✅ Notifications & Tooltips
✅ Icon Support

📜 Basic Usage
lua
local UI = NixteraUI:Create({
    Theme = "Dark", -- "Dark" or "Light"
    AccentColor = Color3.fromRGB(100, 70, 200),
    Font = Enum.Font.GothamSemibold
})

-- Create a window
local Window = UI:Window({
    Title = "NixteraUI Demo",
    Size = UDim2.fromOffset(450, 550),
    Position = UDim2.fromOffset(100, 100),
    AutoShow = true
})

-- Add a tab
local MainTab = Window:Tab("Main", "rbxassetid://123456")

-- Add a section
local PlayerSection = MainTab:Section("Player")

-- Button
PlayerSection:Button({
    Text = "Teleport to Base",
    Icon = "rbxassetid://234567",
    Callback = function()
        print("Teleport activated!")
    end
})

-- Toggle
PlayerSection:Toggle({
    Text = "God Mode",
    Default = false,
    Callback = function(State)
        print("God Mode:", State)
    end
})

-- Slider
PlayerSection:Slider({
    Text = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(Value)
        print("Speed:", Value)
    end
})

-- Notification
UI:Notify({
    Title = "Success!",
    Content = "NixteraUI loaded!",
    Duration = 3,
    Type = "Success" -- "Info", "Warning", "Error"
})
🎨 Customization
Available Settings:
lua
NixteraUI:UpdateConfig({
    Theme = "Dark", -- "Dark" or "Light"
    AccentColor = Color3.fromRGB(100, 70, 200),
    BackgroundColor = Color3.fromRGB(30, 30, 40),
    TextColor = Color3.fromRGB(240, 240, 240),
    CornerRadius = 8, -- Border radius
    DropShadow = true, -- Element shadows
    Animations = true, -- Smooth animations
    Tooltips = true -- Hover tooltips
})
📌 Additional Features
1. Notifications
lua
UI:Notify({
    Title = "Warning!",
    Content = "This is a test notification.",
    Duration = 5,
    Type = "Warning" -- "Info", "Success", "Error"
})
2. Context Menu
lua
UI:ContextMenu({
    Options = {
        {Text = "Copy", Callback = function() print("Copying...") end},
        {Text = "Paste", Callback = function() print("Pasting...") end}
    }
})
3. Loading Screen
lua
local Loader = UI:Loader({
    Title = "Loading...",
    Subtitle = "Please wait",
    Duration = 3 -- Auto-close after N seconds
})
🔮 Roadmap
Custom Themes (save/load presets)

Data Tables & Lists

Charts & Progress Indicators

Mobile Support

📥 GitHub Repository
NixteraUI GitHub (🔜 coming soon)

💬 Feedback
Want to suggest features or improvements? Open an Issue on GitHub!

NixteraUI — a stylish, powerful Lua UI framework! 🚀
