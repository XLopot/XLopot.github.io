local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Aimbot = {
    Target = nil,
    FOVCircle = nil,
    Connections = {}
}

function Aimbot:Initialize(settings, utils, events)
    self.Settings = settings
    self.Utils = utils
    self.Events = events
    
    -- Create FOV circle
    self:CreateFOVCircle()
end

function Aimbot:CreateFOVCircle()
    if not self.Settings:Get("Aim.FOVCircle") then return end
    
    self.FOVCircle = Drawing.new("Circle")
    self.FOVCircle.Visible = self.Settings:Get("Aim.Enabled")
    self.FOVCircle.Radius = self.Settings:Get("Aim.FOV")
    self.FOVCircle.Color = Color3.new(1, 1, 1)
    self.FOVCircle.Thickness = 1
    self.FOVCircle.Filled = false
    self.FOVCircle.Position = Vector2.new(self.Utils.Camera.ViewportSize.X / 2, self.Utils.Camera.ViewportSize.Y / 2)
end

function Aimbot:Update()
    if not self.Settings:Get("Aim.Enabled") then
        if self.Target then self.Target = nil end
        if self.FOVCircle then self.FOVCircle.Visible = false end
        return
    end
    
    -- Update FOV circle
    if self.FOVCircle then
        self.FOVCircle.Visible = self.Settings:Get("Aim.FOVCircle")
        self.FOVCircle.Radius = self.Settings:Get("Aim.FOV")
    end
    
    -- Check if aim key is pressed
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType[self.Settings:Get("Aim.Key")]) then
        self.Target = self:GetClosestTarget()
        if self.Target then
            self:AimAt(self.Target)
        end
    else
        self.Target = nil
    end
end

function Aimbot:GetClosestTarget()
    local closestPlayer = nil
    local closestDistance = self.Settings:Get("Aim.FOV")
    local closestHitbox = nil
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == self.Utils.LocalPlayer then continue end
        if not player.Character then continue end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        -- Team check
        if not self.Utils:TeamCheck(player) then continue end
        
        -- Check hitboxes in priority order
        local targetHitbox = nil
        for _, hitboxName in ipairs(self.Settings:Get("Aim.HitboxPriority")) do
            local hitbox = player.Character:FindFirstChild(hitboxName)
            if hitbox then
                targetHitbox = hitbox
                break
            end
        end
        
        if not targetHitbox then continue end
        
        -- Visible check
        if self.Settings:Get("Aim.VisibleCheck") and not self.Utils:IsVisible(targetHitbox) then
            continue
        end
        
        -- Calculate distance to mouse
        local screenPoint, visible = self.Utils.Camera:WorldToViewportPoint(targetHitbox.Position)
        if not visible then continue end
        
        local mousePosition = UserInputService:GetMouseLocation()
        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePosition).Magnitude
        
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = player
            closestHitbox = targetHitbox
        end
    end
    
    return closestPlayer, closestHitbox
end

function Aimbot:AimAt(targetPlayer, targetHitbox)
    if not targetPlayer or not targetPlayer.Character then return end
    
    -- Find the hitbox if not provided
    if not targetHitbox then
        for _, hitboxName in ipairs(self.Settings:Get("Aim.HitboxPriority")) do
            local hitbox = targetPlayer.Character:FindFirstChild(hitboxName)
            if hitbox then
                targetHitbox = hitbox
                break
            end
        end
    end
    
    if not targetHitbox then return end
    
    -- Calculate prediction
    local cameraPosition = self.Utils.Camera.CFrame.Position
    local targetPosition = self.Utils:CalculatePrediction(targetHitbox, self.Settings:Get("Aim.Prediction"))
    
    -- Calculate direction
    local direction = (targetPosition - cameraPosition).Unit
    local currentDirection = self.Utils.Camera.CFrame.LookVector
    
    -- Apply smoothing
    local smoothness = math.clamp(self.Settings:Get("Aim.Smoothness") / 100, 0.01, 1)
    local newDirection = currentDirection:Lerp(direction, smoothness)
    
    -- Set camera direction
    self.Utils.Camera.CFrame = CFrame.new(cameraPosition, cameraPosition + newDirection)
end

function Aimbot:Destroy()
    if self.FOVCircle then
        self.FOVCircle:Remove()
        self.FOVCircle = nil
    end
    
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    
    self.Target = nil
end

return Aimbot