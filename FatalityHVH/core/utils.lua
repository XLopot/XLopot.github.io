local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local Utils = {}

function Utils:Initialize(settings)
    self.Settings = settings
    self.LocalPlayer = Players.LocalPlayer
    self.Camera = Camera
end

-- Obfuscate function calls for anti-cheat evasion
function Utils:ObfuscateCall(func, ...)
    if not self.Settings:Get("AntiCheat.ObfuscateCalls") then
        return func(...)
    end
    
    -- Random delay to avoid pattern detection
    if self.Settings:Get("AntiCheat.RandomizeValues") then
        task.wait(math.random() * 0.01)
    end
    
    -- Obfuscate call using pcall
    local success, result = pcall(func, ...)
    
    if success then
        return result
    else
        -- Return dummy data if call fails
        return nil
    end
end

-- Get player from character
function Utils:GetPlayerFromCharacter(character)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character == character then
            return player
        end
    end
    return nil
end

-- Check if a part is visible
function Utils:IsVisible(part, ignoreList)
    if not part then return false end
    
    local ignore = ignoreList or {self.LocalPlayer.Character, Camera}
    local origin = self.Camera.CFrame.Position
    local target = part.Position
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = ignore
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, (target - origin).Unit * 1000, raycastParams)
    
    if result and result.Instance:FindFirstAncestorWhichIsA("Model") == part:FindFirstAncestorWhichIsA("Model") then
        return true
    end
    
    return false
end

-- Calculate prediction for moving targets
function Utils:CalculatePrediction(target, predictionValue)
    if not target or not predictionValue or predictionValue <= 0 then
        return target.Position
    end
    
    local velocity = target.Velocity or Vector3.new(0, 0, 0)
    return target.Position + (velocity * predictionValue)
end

-- Team check
function Utils:TeamCheck(player)
    if not self.Settings:Get("Aim.TeamCheck") then
        return true
    end
    
    return player.Team ~= self.LocalPlayer.Team
end

-- Distance between two positions
function Utils:GetDistance(position1, position2)
    return (position1 - position2).Magnitude
end

-- Screen position from world position
function Utils:WorldToScreen(position)
    return self.Camera:WorldToViewportPoint(position)
end

-- Check if position is on screen
function Utils:IsOnScreen(position)
    local screenPos, visible = self.Camera:WorldToViewportPoint(position)
    return visible
end

return Utils