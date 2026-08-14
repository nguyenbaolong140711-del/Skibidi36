-- [[ LIWCN V2 - FIX ESP BÁM NGƯỜI + FOV CĂN GIỮA ]] --
local Settings = {
    Aimbot_Enabled = true,
    FOV_Radius = 100,
    Aimbot_Smoothness = 1,
    Team_Check = false,
    
    ESP_Enabled = true,
    Box_Color = Color3.fromRGB(255, 255, 255),
    HealthBar_Color = Color3.fromRGB(0, 255, 0),
    
    Hitbox_Enabled = true,
    Hitbox_Size = 10.0,
    Hitbox_Transparency = 0.5,
    
    AutoCollectMoney = true,
    CollectRadius = 50,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ GUI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LIWCN_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- [[ FOV CIRCLE - FIX CĂN GIỮA ]] --
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = Settings.Aimbot_Enabled
FOV_Circle.Radius = Settings.FOV_Radius
FOV_Circle.Color = Color3.fromRGB(255, 0, 0)
FOV_Circle.Thickness = 2
FOV_Circle.Filled = false

-- [[ MENU ]] --
local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 180, 0, 200)
Menu.Position = UDim2.new(0.05, 0, 0.3, 0)
Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Menu.Active = true
Menu.Draggable = true
Menu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = Menu

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Thickness = 2
MenuStroke.Color = Color3.fromRGB(255, 0, 0)
MenuStroke.Parent = Menu

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Text = "LIWCN V2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Parent = Menu

local function CreateButton(text, y, getConfig, setConfig)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 150, 0, 30)
    Btn.Position = UDim2.new(0.5, -75, 0, y)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Parent = Menu
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    local function Update()
        local enabled = getConfig()
        Btn.Text = text .. (enabled and ": ON" or ": OFF")
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(150, 40, 60)
    end
    Update()
    
    Btn.MouseButton1Click:Connect(function()
        setConfig(not getConfig())
        Update()
    end)
end

CreateButton("Aimbot", 40, function() return Settings.Aimbot_Enabled end, function(v) Settings.Aimbot_Enabled = v FOV_Circle.Visible = v end)
CreateButton("ESP", 75, function() return Settings.ESP_Enabled end, function(v) Settings.ESP_Enabled = v end)
CreateButton("Hitbox", 110, function() return Settings.Hitbox_Enabled end, function(v) Settings.Hitbox_Enabled = v end)
CreateButton("Nhặt Tiền", 145, function() return Settings.AutoCollectMoney end, function(v) Settings.AutoCollectMoney = v end)

-- [[ FIX ESP - BÁM ĐÚNG NGƯỜI ]] --
local function GetCharacterElements(model)
    if not model or model == LocalPlayer.Character then return nil end
    local Humanoid = model:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return nil end
    
    local Head = model:FindFirstChild("Head") or model:FindFirstChild("EnemyHead")
    local Root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
    
    if Head and Root then return Head, Root, Humanoid end
    return nil
end

local function IsValidEnemyPlayer(player)
    if player == LocalPlayer then return false end
    if Settings.Team_Check and player.Team == LocalPlayer.Team then return false end
    return true
end

-- [[ ESP SYSTEM - FIX VỊ TRÍ ]] --
local ESP_Boxes = {}

local function UpdateESP(player, Head, Root, Humanoid)
    local model = player.Character
    local gui = ESP_Boxes[model]

    if not Settings.ESP_Enabled then
        if gui then gui.Box.Visible = false end
        return
    end

    if not gui then
        local BoxFrame = Instance.new("Frame")
        BoxFrame.BackgroundTransparency = 1
        BoxFrame.Parent = ScreenGui

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Settings.Box_Color
        Stroke.Thickness = 1.2
        Stroke.Parent = BoxFrame

        local HealthBg = Instance.new("Frame")
        HealthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        HealthBg.Parent = BoxFrame

        local HealthBar = Instance.new("Frame")
        HealthBar.BackgroundColor3 = Settings.HealthBar_Color
        HealthBar.Parent = HealthBg

        local NameLabel = Instance.new("TextLabel")
        NameLabel.BackgroundTransparency = 1
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.TextSize = 9
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextStrokeTransparency = 0
        NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        NameLabel.Parent = BoxFrame

        gui = { 
            Box = BoxFrame, 
            HealthBg = HealthBg, 
            HealthBar = HealthBar, 
            Name = NameLabel 
        }
        ESP_Boxes[model] = gui
    end

    -- FIX: Dùng đúng vị trí 3D và chuyển sang 2D
    local HeadPos3D = Head.Position
    local RootPos3D = Root.Position
    
    -- Lấy vị trí 2D trên màn hình
    local HeadScreenPos, HeadVisible = Camera:WorldToScreenPoint(HeadPos3D)
    local RootScreenPos, RootVisible = Camera:WorldToScreenPoint(RootPos3D)
    
    if HeadVisible and RootVisible then
        -- Tính height và width
        local Height = math.abs(HeadScreenPos.Y - RootScreenPos.Y)
        local Width = Height / 1.5
        
        -- Vị trí box - ĐẶT ĐÚNG TẠI VỊ TRÍ NGƯỜI
        local BoxX = HeadScreenPos.X - Width / 2
        local BoxY = HeadScreenPos.Y
        
        gui.Box.Size = UDim2.new(0, Width, 0, Height)
        gui.Box.Position = UDim2.new(0, BoxX, 0, BoxY)
        gui.Box.Visible = true
        
        -- HealthBar
        gui.HealthBg.Size = UDim2.new(0, 2, 1, 0)
        gui.HealthBg.Position = UDim2.new(0, -5, 0, 0)
        
        local HealthPercent = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
        gui.HealthBar.Size = UDim2.new(1, 0, HealthPercent, 0)
        gui.HealthBar.Position = UDim2.new(0, 0, 1 - HealthPercent, 0)
        
        -- Tên
        gui.Name.Size = UDim2.new(1, 0, 0, 12)
        gui.Name.Position = UDim2.new(0, 0, 0, -14)
        gui.Name.Text = player.Name
    else
        gui.Box.Visible = false
    end
end

-- [[ HITBOX ]] --
local CachedTargets = {}
local OriginalSizes = {}

task.spawn(function()
    while task.wait(0.2) do
        local CurrentTargets = {}
        local ScannedModels = {}
        
        for _, player in ipairs(Players:GetPlayers()) do
            if IsValidEnemyPlayer(player) and player.Character then
                local model = player.Character
                local Head, Root, Humanoid = GetCharacterElements(model)
                
                if Head and Root and Humanoid then
                    table.insert(CurrentTargets, {Model = model, Head = Head, Root = Root, Humanoid = Humanoid, Player = player})
                    ScannedModels[model] = true
                    
                    if not OriginalSizes[model] then 
                        OriginalSizes[model] = Head.Size 
                    end
                    
                    if Settings.Hitbox_Enabled then
                        Head.Massless = true
                        Head.CanCollide = false
                        Head.Size = Vector3.new(Settings.Hitbox_Size, Settings.Hitbox_Size, Settings.Hitbox_Size)
                        Head.Transparency = Settings.Hitbox_Transparency
                    else
                        Head.Size = OriginalSizes[model] or Vector3.new(2, 1, 1)
                        Head.Transparency = 0
                        Head.CanCollide = true
                        Head.Massless = false
                    end
                end
            end
        end
        
        for model, size in pairs(OriginalSizes) do
            if not ScannedModels[model] and model:FindFirstChild("Head") then
                model.Head.Size = size
                model.Head.Transparency = 0
                model.Head.CanCollide = true
                model.Head.Massless = false
                OriginalSizes[model] = nil
            end
        end
        
        CachedTargets = CurrentTargets
    end
end)

-- [[ ENGINE CHÍNH - FIX FOV + AIMBOT + ESP ]] --
RunService.RenderStepped:Connect(function()
    local ViewportSize = Camera.ViewportSize
    local ScreenCenter = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
    
    -- FIX FOV: Căn giữa chính xác
    FOV_Circle.Position = ScreenCenter
    
    local ClosestTargetHead = nil
    local MaxDistance = Settings.FOV_Radius
    local ActiveModels = {}

    for _, target in ipairs(CachedTargets) do
        local model = target.Model
        local Head = target.Head
        local Root = target.Root
        local Humanoid = target.Humanoid
        local player = target.Player
        
        if model.Parent and Humanoid.Health > 0 then
            ActiveModels[model] = true
            UpdateESP(player, Head, Root, Humanoid)
            
            if Settings.Aimbot_Enabled then
                local ScreenPos, OnScreen = Camera:WorldToScreenPoint(Head.Position)
                if OnScreen then
                    local DistanceToCenter = (Vector2.new(ScreenPos.X, ScreenPos.Y) - ScreenCenter).Magnitude
                    if DistanceToCenter < MaxDistance then
                        MaxDistance = DistanceToCenter
                        ClosestTargetHead = Head
                    end
                end
            end
        end
    end
    
    if Settings.Aimbot_Enabled and ClosestTargetHead and LocalPlayer.Character then
        local TargetCFrame = CFrame.lookAt(Camera.CFrame.Position, ClosestTargetHead.Position)
        if Settings.Aimbot_Smoothness >= 1 then
            Camera.CFrame = TargetCFrame
        else
            Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, Settings.Aimbot_Smoothness)
        end
    end
    
    for model, gui in pairs(ESP_Boxes) do
        if not ActiveModels[model] or not Settings.ESP_Enabled then
            gui.Box:Destroy()
            ESP_Boxes[model] = nil
        end
    end
end)

-- [[ AUTO NHẶT TIỀN ]] --
local moneyCache = {}
local lastMoneyScan = 0

task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoCollectMoney then
            local character = LocalPlayer.Character
            if not character then continue end
            
            local playerRoot = character:FindFirstChild("HumanoidRootPart")
            if not playerRoot then continue end
            
            if tick() - lastMoneyScan > 2 then
                moneyCache = {}
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Size.Magnitude < 15 then
                        local name = string.lower(v.Name)
                        local parentName = v.Parent and string.lower(v.Parent.Name) or ""
                        
                        if string.find(name, "money") or string.find(name, "cash") or 
                           string.find(name, "coin") or string.find(name, "tien") or
                           string.find(name, "bill") or string.find(name, "dollar") or
                           string.find(name, "gold") or string.find(name, "gem") or
                           string.find(parentName, "money") or string.find(parentName, "cash") or
                           string.find(parentName, "coin") then
                            table.insert(moneyCache, v)
                        end
                    end
                end
                
                lastMoneyScan = tick()
            end
            
            for _, money in pairs(moneyCache) do
                if money and money.Parent then
                    local distance = (money.Position - playerRoot.Position).Magnitude
                    if distance <= Settings.CollectRadius then
                        if distance > 10 then
                            playerRoot.CFrame = CFrame.new(money.Position + Vector3.new(0, 3, 0))
                        end
                        firetouchinterest(playerRoot, money, 0)
                        firetouchinterest(playerRoot, money, 1)
                    end
                end
            end
        end
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "LIWCN V2",
    Text = "ESP + FOV đã fix! Bám đúng người!",
    Duration = 5
})

print("LIWCN V2 - LOADED! ESP + FOV FIXED!")
