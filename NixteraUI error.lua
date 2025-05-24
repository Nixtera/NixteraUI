local NixteraUI = {}
NixteraUI.__index = NixteraUI

function NixteraUI.new(parent, config)
    local self = setmetatable({}, NixteraUI)
    self.Config = config or {}
    self.Parent = parent or game:GetService("CoreGui")
    return self
end

function NixteraUI:CreateUI()
    local ui = {}
    
    function ui:CreateWindow(options)
        print("Created window:", options.Title)
        return {
            CreateTab = function() print("Tab created") end
        }
    end
    
    return ui
end

-- Экспорт библиотеки
return NixteraUI
