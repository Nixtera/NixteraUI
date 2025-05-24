# **NixteraUI - Modern Lua UI Framework**  

A sleek, customizable UI library for Lua environments (Roblox, FiveM, Love2D, etc.) with smooth animations and dark/light themes.

## 📥 Installation
```lua
local NixteraUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nixtera/NixteraUI/refs/heads/main/NixteraUI.lua"))()
```

## ✨ Features
- 🎨 Customizable colors and themes
- 🖱️ Multiple UI elements (buttons, toggles, sliders, dropdowns)
- 🌓 Dark/light mode support
- ✨ Smooth animations
- 🔔 Notification system
- ℹ️ Tooltips
- 🖼️ Icon support

## 📚 Documentation

### Creating a Window
```lua
local UI = NixteraUI:Create({
    Theme = "Dark", -- "Dark" or "Light"
    AccentColor = Color3.fromRGB(100, 70, 200)
})

local Window = UI:Window({
    Title = "My App",
    Size = UDim2.fromOffset(500, 600),
    Position = UDim2.fromOffset(100, 100)
})
```

### Adding Elements
```lua
local Tab = Window:Tab("Main")
local Section = Tab:Section("Settings")

Section:Button({
    Text = "Click Me",
    Callback = function()
        print("Button pressed!")
    end
})

Section:Toggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(state)
        print("Toggle state:", state)
    end
})
```

### Customization
```lua
NixteraUI:UpdateConfig({
    Theme = "Light",
    AccentColor = Color3.fromRGB(255, 100, 100),
    CornerRadius = 12
})
```

## 🚀 Roadmap
- [ ] Theme presets system
- [ ] Advanced data tables
- [ ] Progress indicators
- [ ] Mobile optimization

## 🤝 Contributing
Contributions are welcome! Please open an issue or pull request on GitHub.

## 📜 License
MIT License
