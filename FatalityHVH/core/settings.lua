local HttpService = game:GetService("HttpService")

local Settings = {
    Data = {}
}

-- Default settings
Settings.Defaults = {
    Aim = {
        Enabled = false,
        Key = "MouseButton2",
        FOV = 100,
        FOVCircle = true,
        Smoothness = 20,
        SmoothingStyle = "Linear",
        Prediction = 0.14,
        PredictionType = "Velocity",
        Hitbox = "Head",
        HitboxPriority = {"Head", "HumanoidRootPart", "Torso"},
        VisibleCheck = true,
        TeamCheck = true,
        AutoFire = false,
        AutoWall = false,
        Silence = false
    },
    Wallhack = {
        Enabled = false,
        Boxes = true,
        BoxStyle = "2D",
        Skeletons = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
        TracerOrigin = "Bottom",
        TeamColor = true,
        Weapon = false,
        OffscreenArrows = true
    },
    Chams = {
        Enabled = false,
        ThroughWalls = true,
        FillColor = Color3.fromRGB(255, 0, 0),
        FillTransparency = 0.5,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        OutlineTransparency = 0,
        Material = "Neon",
        PulseEffect = false
    },
    BulletTracers = {
        Enabled = false,
        Color = Color3.fromRGB(255, 50, 50),
        Lifetime = 3,
        Thickness = 1
    },
    Speedhack = {
        Enabled = false,
        Speed = 1.5
    },
    World = {
        Enabled = false,
        NightMode = false,
        FullBright = false,
        ColorCorrection = false,
        RemoveFog = false,
        WeaponESP = false
    },
    AntiCheat = {
        Enabled = false,
        RandomizeValues = true,
        ObfuscateCalls = true,
        FakePackets = false,
        CloakESP = false
    },
    Menu = {
        Key = "RightShift",
        Open = false,
        AccentColor = Color3.fromRGB(235, 5, 90),
        Theme = "Dark",
        Scale = 1
    }
}

-- Load settings
function Settings:Load()
    -- In a real implementation, you might load from a config file
    -- For now, we'll just use defaults
    self.Data = HttpService:JSONDecode(HttpService:JSONEncode(self.Defaults))
end

-- Save settings
function Settings:Save()
    -- In a real implementation, you might save to a config file
    -- For now, we'll just keep in memory
end

-- Get a setting value
function Settings:Get(path)
    local parts = string.split(path, ".")
    local value = self.Data
    
    for _, part in ipairs(parts) do
        if value[part] then
            value = value[part]
        else
            return nil
        end
    end
    
    return value
end

-- Set a setting value
function Settings:Set(path, value)
    local parts = string.split(path, ".")
    local current = self.Data
    
    for i = 1, #parts - 1 do
        if not current[parts[i]] then
            current[parts[i]] = {}
        end
        current = current[parts[i]]
    end
    
    current[parts[#parts]] = value
    self:Save()
end

return Settings