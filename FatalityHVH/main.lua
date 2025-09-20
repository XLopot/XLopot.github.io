-- Fatality.cc Enhanced HVH Cheat
-- WARNING: Using cheats violates Roblox Terms of Service

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Load core modules
local Settings = loadstring(readfile("FatalityHVH/core/settings.lua"))()
local Events = loadstring(readfile("FatalityHVH/core/events.lua"))()
local Utils = loadstring(readfile("FatalityHVH/core/utils.lua"))()

-- Load feature modules
local Aimbot = loadstring(readfile("FatalityHVH/modules/aimbot.lua"))()
local ESP = loadstring(readfile("FatalityHVH/modules/esp.lua"))()
local Visuals = loadstring(readfile("FatalityHVH/modules/visuals.lua"))()
local Movement = loadstring(readfile("FatalityHVH/modules/movement.lua"))()
local Combat = loadstring(readfile("FatalityHVH/modules/combat.lua"))()
local Tracers = loadstring(readfile("FatalityHVH/modules/tracers.lua"))()

-- Load UI modules
local Menu = loadstring(readfile("FatalityHVH/ui/menu.lua"))()
local Themes = loadstring(readfile("FatalityHVH/ui/themes.lua"))()
local Elements = loadstring(readfile("FatalityHVH/ui/elements.lua"))()

-- Main class
local FatalityHVH = {
    Enabled = false,
    Modules = {
        Aimbot = Aimbot,
        ESP = ESP,
        Visuals = Visuals,
        Movement = Movement,
        Combat = Combat,
        Tracers = Tracers
    },
    UI = {
        Menu = Menu,
        Themes = Themes,
        Elements = Elements
    }
}

-- Initialize the cheat
function FatalityHVH:Initialize()
    -- Initialize settings
    Settings:Load()
    
    -- Initialize utilities
    Utils:Initialize(Settings)
    
    -- Initialize events
    Events:Initialize(Settings, Utils)
    
    -- Initialize modules
    for name, module in pairs(self.Modules) do
        if module.Initialize then
            module:Initialize(Settings, Utils, Events)
        end
    end
    
    -- Initialize UI
    self.UI.Menu:Initialize(Settings, Utils, self.Modules)
    
    -- Set up event connections
    self:SetupConnections()
    
    self.Enabled = true
    print("Fatality.cc HVH Cheat Loaded!")
    print("Press " .. Settings.Menu.Key .. " to open the menu")
end

-- Set up event connections
function FatalityHVH:SetupConnections()
    -- Menu toggle
    Events:AddConnection("MenuToggle", UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode[Settings.Menu.Key] then
            Settings.Menu.Open = not Settings.Menu.Open
            self.UI.Menu:SetVisible(Settings.Menu.Open)
        end
    end))
    
    -- Render stepped for continuous updates
    Events:AddConnection("RenderStepped", RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        
        -- Update all modules
        for name, module in pairs(self.Modules) do
            if module.Update then
                module:Update()
            end
        end
    end))
    
    -- Player added/removed events
    Events:AddConnection("PlayerAdded", Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if Settings.Wallhack.Enabled then
                ESP:CreatePlayerESP(player)
            end
            if Settings.Chams.Enabled then
                Visuals:CreatePlayerChams(player)
            end
        end)
    end))
    
    Events:AddConnection("PlayerRemoving", Players.PlayerRemoving:Connect(function(player)
        ESP:RemovePlayerESP(player)
        Visuals:RemovePlayerChams(player)
    end))
end

-- Cleanup function
function FatalityHVH:Destroy()
    self.Enabled = false
    
    -- Disable all modules
    for name, module in pairs(self.Modules) do
        if module.Destroy then
            module:Destroy()
        end
    end
    
    -- Destroy UI
    self.UI.Menu:Destroy()
    
    -- Disconnect all events
    Events:DisconnectAll()
    
    print("Fatality.cc HVH Cheat Unloaded!")
end

-- Initialize the cheat
FatalityHVH:Initialize()

-- Return the main class for external access if needed
return FatalityHVH