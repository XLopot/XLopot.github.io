local TweenService = game:GetService("TweenService")

local Menu = {
    ScreenGui = nil,
    MainFrame = nil,
    Tabs = {},
    CurrentTab = nil
}

function Menu:Initialize(settings, utils, modules)
    self.Settings = settings
    self.Utils = utils
    self.Modules = modules
    
    self:CreateUI()
end

function Menu:CreateUI()
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "FatalityUI"
    self.ScreenGui.Parent = game.CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Enabled = self.Settings:Get("Menu.Open")
    
    -- Create main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 500, 0, 350)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 57)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Visible = self.Settings:Get("Menu.Open")
    self.MainFrame.Parent = self.ScreenGui
    
    -- Add UI corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = self.MainFrame
    
    -- Add UI stroke
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = self.Settings:Get("Menu.AccentColor")
    UIStroke.Thickness = 2
    UIStroke.Parent = self.MainFrame
    
    -- Create header
    self:CreateHeader()
    
    -- Create tabs
    self:CreateTabs()
    
    -- Create tab contents
    self:CreateTabContents()
end

function Menu:CreateHeader()
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(31, 25, 66)
    Header.BorderSizePixel = 0
    Header.Parent = self.MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "FATALITY.CC HVH CHEAT"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header
    
    CloseButton.MouseButton1Click:Connect(function()
        self:SetVisible(false)
        self.Settings:Set("Menu.Open", false)
    end)
end

function Menu:CreateTabs()
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "Tabs"
    TabsFrame.Size = UDim2.new(0, 120, 1, -40)
    TabsFrame.Position = UDim2.new(0, 0, 0, 40)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(31, 25, 66)
    TabsFrame.BackgroundTransparency = 0.1
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = self.MainFrame
    
    local TabNames = {"Aim", "Visuals", "Movement", "Combat", "World", "Settings"}
    
    for i, tabName in ipairs(TabNames) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Position = UDim2.new(0, 5, 0, (i-1) * 35 + 5)
        TabButton.BackgroundColor3 = Color3.fromRGB(31, 25, 66)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.new(1, 1, 1)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabsFrame
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -120, 1, -40)
        TabContent.Position = UDim2.new(0, 120, 0, 40)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = i == 1
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = self.Settings:Get("Menu.AccentColor")
        TabContent.Parent = self.MainFrame
        
        self.Tabs[tabName] = {
            Button = TabButton,
            Content = TabContent
        }
        
        TabButton.MouseButton1Click:Connect(function()
            self:SwitchTab(tabName)
        end)
    end
    
    -- Set first tab as active
    self:SwitchTab("Aim")
end

function Menu:SwitchTab(tabName)
    for name, tab in pairs(self.Tabs) do
        tab.Content.Visible = (name == tabName)
        tab.Button.BackgroundColor3 = (name == tabName) and self.Settings:Get("Menu.AccentColor") or Color3.fromRGB(31, 25, 66)
    end
    self.CurrentTab = tabName
    
    -- Populate tab content if empty
    self:PopulateTabContent(tabName)
end

function Menu:PopulateTabContent(tabName)
    local content = self.Tabs[tabName].Content
    
    -- Clear existing content (except UIListLayout if it exists)
    for _, child in ipairs(content:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    -- Add UIListLayout if it doesn't exist
    if not content:FindFirstChild("UIListLayout") then
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.Parent = content
    end
    
    -- Add content based on tab
    if tabName == "Aim" then
        self:CreateAimTabContent(content)
    elseif tabName == "Visuals" then
        self:CreateVisualsTabContent(content)
    elseif tabName == "Movement" then
        self:CreateMovementTabContent(content)
    elseif tabName == "Combat" then
        self:CreateCombatTabContent(content)
    elseif tabName == "World" then
        self:CreateWorldTabContent(content)
    elseif tabName == "Settings" then
        self:CreateSettingsTabContent(content)
    end
end

function Menu:CreateAimTabContent(content)
    -- Aim enabled toggle
    local AimToggle = self:CreateToggle("Aim Enabled", "Aim.Enabled", content)
    
    -- FOV slider
    local FOVSlider = self:CreateSlider("FOV", "Aim.FOV", 0, 360, content)
    
    -- Smoothness slider
    local SmoothnessSlider = self:CreateSlider("Smoothness", "Aim.Smoothness", 0, 100, content)
    
    -- Prediction slider
    local PredictionSlider = self:CreateSlider("Prediction", "Aim.Prediction", 0, 1, content, 0.01)
    
    -- More aim settings...
end

function Menu:CreateToggle(name, settingPath, parent)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = name .. "Toggle"
    ToggleButton.Size = UDim2.new(1, -20, 0, 30)
    ToggleButton.Position = UDim2.new(0, 10, 0, 10)
    ToggleButton.BackgroundColor3 = self.Settings:Get(settingPath) and self.Settings:Get("Menu.AccentColor") or Color3.fromRGB(60, 60, 60)
    ToggleButton.Text = name .. ": " .. tostring(self.Settings:Get(settingPath))
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newValue = not self.Settings:Get(settingPath)
        self.Settings:Set(settingPath, newValue)
        ToggleButton.Text = name .. ": " .. tostring(newValue)
        ToggleButton.BackgroundColor3 = newValue and self.Settings:Get("Menu.AccentColor") or Color3.fromRGB(60, 60, 60)
    end)
    
    return ToggleButton
end

function Menu:CreateSlider(name, settingPath, min, max, parent, step)
    step = step or 1
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name .. ": " .. tostring(self.Settings:Get(settingPath))
    SliderLabel.TextColor3 = Color3.new(1, 1, 1)
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.Parent = SliderFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 4)
    SliderCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((self.Settings:Get(settingPath) - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = self.Settings:Get("Menu.AccentColor")
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 4)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((self.Settings:Get(settingPath) - min) / (max - min), -10, 0.5, -10)
    SliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(1, 0)
    SliderButtonCorner.Parent = SliderButton
    
    -- Slider dragging logic
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            
            local value = min + (max - min) * relativeX
            value = math.floor(value / step) * step -- Snap to step
            
            self.Settings:Set(settingPath, value)
            SliderLabel.Text = name .. ": " .. tostring(value)
            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
        end
    end)
    
    return SliderFrame
end

function Menu:SetVisible(visible)
    self.ScreenGui.Enabled = visible
    self.MainFrame.Visible = visible
end

function Menu:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
end

return Menu