-- [[ LIWCN HACK - FULL MENU ]] --
-- Menu mới: LIWCN
-- Chức năng: Aimbot, ESP, Hitbox, Nhặt Tiền

local Settings = {
    -- Aimbot
    Aimbot_Enabled = true,
    FOV_Radius = 100,
    Aimbot_Smoothness = 1,
    Team_Check = false,
    
    -- ESP
    ESP_Enabled = true,
    Box_Color = Color3.fromRGB(255, 255, 255),
    HealthBar_Color = Color3.fromRGB(0, 255, 0),
    
    -- Hitbox
    Hitbox_Enabled = true,
    Hitbox_Size = 10.0,
    Hitbox_Transparency = 0.5,
    
    -- Cướp
    AutoCollectMoney = true,
    CollectRadius = 50,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- [[ TẠO GUI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LIWCN"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- [[ FOV CIRCLE ]] --
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = Settings.Aimbot_Enabled
FOV_Circle.Radius = Settings.FOV_Radius
FOV_Circle.Color = Color3.fromRGB(255, 0, 0)
FOV_Circle.Thickness = 2
FOV_Circle.Filled = false
FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

RunService.RenderStepped:Connect(function()
    FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

-- [[ MENU LIWCN ]] --
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

-- Title LIWCN
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.Text = "LIWCN"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Parent = Menu

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Chức năng tạo nút
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

-- Các nút chức năng
CreateButton("Aimbot", 40, function() return Settings.Aimbot_Enabled end, function(v) Settings.Aimbot_Enabled = v FOV_Circle.Visible = v end)
CreateButton("ESP", 75, function() return Settings.ESP_Enabled end, function(v) Settings.ESP_Enabled = v end)
CreateButton("Hitbox", 110, function() return Settings.Hitbox_Enabled end, function(v) Settings.Hitbox_Enabled = v end)
CreateButton("Nhặt Tiền", 145, function() return Settings.AutoCollectMoney end, function(v) Settings.AutoCollectMoney = v end)

-- [[ BỘ LỌC ĐỐI THỦ ]] --
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

-- [[ HỆ THỐNG ESP ]] --
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

    local HeadPos, HeadOnScreen = Camera:WorldToViewportPoint(Head.Position)
    local RootPos, RootOnScreen = Camera:WorldToViewportPoint(Root.Position)

    if HeadOnScreen and RootOnScreen then
        local Height = math.abs(HeadPos.Y - RootPos.Y) * 2
        local Width = Height / 1.8
        local BoxY = HeadPos.Y - Height * 0.1
        
        gui.Box.Size = UDim2.new(0, Width, 0, Height)
        gui.Box.Position = UDim2.new(0, HeadPos.X - Width / 2, 0, BoxY)
        gui.Box.Visible = true
        
        gui.HealthBg.Size = UDim2.new(0, 2, 1, 0)
        gui.HealthBg.Position = UDim2.new(0, -5, 0, 0)
        
        local HealthPercent = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
        gui.HealthBar.Size = UDim2.new(1, 0, HealthPercent, 0)
        gui.HealthBar.Position = UDim2.new(0, 0, 1 - HealthPercent, 0)
        
        gui.Name.Size = UDim2.new(1, 0, 0, 12)
        gui.Name.Position = UDim2.new(0, 0, 0, -14)
        gui.Name.Text = player.Name
    else
        gui.Box.Visible = false
    end
end

-- [[ HỆ THỐNG HITBOX ]] --
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

-- [[ ENGINE AIMBOT + ESP ]] --
RunService.RenderStepped:Connect(function()
    local ViewportSize = Camera.ViewportSize
    local ScreenCenter = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
    
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
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Head.Position)
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
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ClickDetector") then
                        local parent = v.Parent
                        if parent and parent:IsA("BasePart") then
                            table.insert(moneyCache, parent)
                        end
                    end
                end
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        local parent = v.Parent
                        if parent and parent:IsA("BasePart") then
                            table.insert(moneyCache, parent)
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
                        
                        local clickDetector = money:FindFirstChildOfClass("ClickDetector") or (money.Parent and money.Parent:FindFirstChildOfClass("ClickDetector"))
                        if clickDetector then
                            fireclickdetector(clickDetector)
                        end
                        
                        local prompt = money:FindFirstChildOfClass("ProximityPrompt") or (money.Parent and money.Parent:FindFirstChildOfClass("ProximityPrompt"))
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
        end
    end
end)

-- [[ THÔNG BÁO ]] --
game.StarterGui:SetCore("SendNotification", {
    Title = "LIWCN",
    Text = "Menu LIWCN đã tải! Aimbot + ESP + Hitbox + Nhặt Tiền",
    Duration = 5
})

print("LIWCN - LOADED!")
