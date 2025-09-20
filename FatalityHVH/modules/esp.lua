local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {
    Objects = {},
    Connections = {}
}

function ESP:Initialize(settings, utils, events)
    self.Settings = settings
    self.Utils = utils
    self.Events = events
end

function ESP:Update()
    if not self.Settings:Get("Wallhack.Enabled") then
        self:ClearAll()
        return
    end
    
    -- Update ESP for all players
    for player, espData in pairs(self.Objects) do
        if not player:IsDescendantOf(Players) or not player.Character then
            self:RemovePlayerESP(player)
            continue
        end
        
        self:UpdatePlayerESP(player)
    end
end

function ESP:CreatePlayerESP(player)
    if self.Objects[player] or player == self.Utils.LocalPlayer then return end
    
    local espData = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        HealthBar = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthText = Drawing.new("Text"),
        Skeleton = {},
        OffscreenArrow = nil
    }
    
    -- Initialize all drawings
    for _, drawing in pairs(espData) do
        if typeof(drawing) == "Instance" and drawing:IsA("Drawing") then
            drawing.Visible = false
            drawing.Thickness = 1
            drawing.ZIndex = 2
        end
    end
    
    -- Specific settings
    espData.Box.Filled = false
    espData.Name.Size = 14
    espData.Name.Center = true
    espData.Name.Outline = true
    espData.Name.Font = 2
    espData.Distance.Size = 14
    espData.Distance.Center = true
    espData.Distance.Outline = true
    espData.Distance.Font = 2
    espData.HealthText.Size = 14
    espData.HealthText.Center = true
    espData.HealthText.Outline = true
    espData.HealthText.Font = 2
    
    -- Create skeleton if enabled
    if self.Settings:Get("Wallhack.Skeletons") then
        self:CreateSkeletonESP(player, espData)
    end
    
    -- Create offscreen arrow if enabled
    if self.Settings:Get("Wallhack.OffscreenArrows") then
        espData.OffscreenArrow = Drawing.new("Triangle")
        espData.OffscreenArrow.Thickness = 1
        espData.OffscreenArrow.Filled = true
        espData.OffscreenArrow.Visible = false
        espData.OffscreenArrow.ZIndex = 2
    end
    
    self.Objects[player] = espData
end

function ESP:RemovePlayerESP(player)
    if not self.Objects[player] then return end
    
    -- Remove all drawings
    for _, drawing in pairs(self.Objects[player]) do
        if typeof(drawing) == "Instance" and drawing:IsA("Drawing") then
            drawing:Remove()
        elseif type(drawing) == "table" then
            for _, line in pairs(drawing) do
                if typeof(line) == "Instance" and line:IsA("Drawing") then
                    line:Remove()
                end
            end
        end
    end
    
    self.Objects[player] = nil
end

function ESP:UpdatePlayerESP(player)
    if not self.Objects[player] then return end
    local espData = self.Objects[player]
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- Team check
    if not self.Utils:TeamCheck(player) then
        for _, drawing in pairs(espData) do
            if typeof(drawing) == "Instance" and drawing:IsA("Drawing") then
                drawing.Visible = false
            elseif type(drawing) == "table" then
                for _, line in pairs(drawing) do
                    if typeof(line) == "Instance" and line:IsA("Drawing") then
                        line.Visible = false
                    end
                end
            end
        end
        return
    end
    
    -- Position calculations
    local position, visible = self.Utils.Camera:WorldToViewportPoint(rootPart.Position)
    if not visible then
        -- Handle offscreen
        if self.Settings:Get("Wallhack.OffscreenArrows") and espData.OffscreenArrow then
            self:UpdateOffscreenArrow(player, espData.OffscreenArrow)
        else
            for _, drawing in pairs(espData) do
                if typeof(drawing) == "Instance" and drawing:IsA("Drawing") then
                    drawing.Visible = false
                elseif type(drawing) == "table" then
                    for _, line in pairs(drawing) do
                        if typeof(line) == "Instance" and line:IsA("Drawing") then
                            line.Visible = false
                        end
                    end
                end
            end
        end
        return
    end
    
    -- Box ESP
    if self.Settings:Get("Wallhack.Boxes") then
        self:UpdateBoxESP(player, espData.Box, position, character)
    else
        espData.Box.Visible = false
    end
    
    -- Tracers
    if self.Settings:Get("Wallhack.Tracers") then
        self:UpdateTracerESP(player, espData.Tracer, position)
    else
        espData.Tracer.Visible = false
    end
    
    -- Health bar
    if self.Settings:Get("Wallhack.Health") then
        self:UpdateHealthESP(player, espData.HealthBar, espData.HealthText, position, humanoid)
    else
        espData.HealthBar.Visible = false
        espData.HealthText.Visible = false
    end
    
    -- Name
    if self.Settings:Get("Wallhack.Names") then
        self:UpdateNameESP(player, espData.Name, position)
    else
        espData.Name.Visible = false
    end
    
    -- Distance
    if self.Settings:Get("Wallhack.Distance") then
        self:UpdateDistanceESP(player, espData.Distance, position, rootPart)
    else
        espData.Distance.Visible = false
    end
    
    -- Skeleton
    if self.Settings:Get("Wallhack.Skeletons") then
        self:UpdateSkeletonESP(player, espData.Skeleton)
    end
    
    -- Offscreen arrow
    if espData.OffscreenArrow then
        espData.OffscreenArrow.Visible = false
    end
end

function ESP:UpdateBoxESP(player, box, position, character)
    -- Implementation for box ESP
end

function ESP:UpdateTracerESP(player, tracer, position)
    -- Implementation for tracer ESP
end

function ESP:UpdateHealthESP(player, healthBar, healthText, position, humanoid)
    -- Implementation for health ESP
end

function ESP:UpdateNameESP(player, nameText, position)
    -- Implementation for name ESP
end

function ESP:UpdateDistanceESP(player, distanceText, position, rootPart)
    -- Implementation for distance ESP
end

function ESP:CreateSkeletonESP(player, espData)
    -- Implementation for skeleton ESP
end

function ESP:UpdateSkeletonESP(player, skeleton)
    -- Implementation for updating skeleton ESP
end

function ESP:UpdateOffscreenArrow(player, arrow)
    -- Implementation for offscreen arrow
end

function ESP:ClearAll()
    for player, _ in pairs(self.Objects) do
        self:RemovePlayerESP(player)
    end
end

function ESP:Destroy()
    self:ClearAll()
    
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
end

return ESP