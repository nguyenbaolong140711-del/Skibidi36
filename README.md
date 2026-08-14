-- [[ LIWCN ULTIMATE - KHÔNG FLY, KHÔNG SPEED ]] --
local Settings = {
    -- Aimbot
    Aimbot_Enabled = true,
    FOV_Radius = 100,
    Aimbot_Smoothness = 1,
    Team_Check = false,
    Aimbot_Part = "Head",
    
    -- ESP
    ESP_Enabled = true,
    Box_Color = Color3.fromRGB(255, 255, 255),
    HealthBar_Color = Color3.fromRGB(0, 255, 0),
    ESP_Distance = true,
    ESP_Health = true,
    ESP_Name = true,
    
    -- Hitbox
    Hitbox_Enabled = true,
    Hitbox_Size = 15.0,
    Hitbox_Transparency = 0.5,
    
    -- Cướp
    AutoCollectMoney = true,
    CollectRadius = 100,
    AutoRob = false,
    
    -- Khác
    AntiAfk = false,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- [[ TẠO GUI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LIWCN_ULTIMATE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- [[ HIỆU ỨNG CHỮ 7 MÀU ]] --
local RainbowText = Instance.new("TextLabel")
RainbowText.Size = UDim2.new(0, 400, 0, 40)
RainbowText.Position = UDim2.new(0.5, -200, 0.15, 0)
RainbowText.BackgroundTransparency = 1
RainbowText.Text = "LIWCN ULTIMATE"
RainbowText.Font = Enum.Font.GothamBold
RainbowText.TextSize = 30
RainbowText.TextStrokeTransparency = 0
RainbowText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
RainbowText.Parent = ScreenGui

local CurrentColor = Color3.fromRGB(255, 255, 255)
RunService.RenderStepped:Connect(function()
    local hue = (tick() % 3) / 3
    CurrentColor = Color3.fromHSV(hue, 1, 1)
    if RainbowText.Parent then
        RainbowText.TextColor3 = CurrentColor
    end
end)

task.delay(3, function()
    if RainbowText.Parent then
        RainbowText:Destroy()
    end
end)

-- [[ FOV CIRCLE ]] --
local FOV_Circle = Instance.new("Frame")
FOV_Circle.AnchorPoint = Vector2.new(0.5, 0.5)
FOV_Circle.BackgroundTransparency = 1
FOV_Circle.Size = UDim2.new(0, Settings.FOV_Radius * 2, 0, Settings.FOV_Radius * 2)
FOV_Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOV_Circle.Visible = Settings.Aimbot_Enabled
FOV_Circle.Parent = ScreenGui

local FOV_Corner = Instance.new("UICorner")
FOV_Corner.CornerRadius = UDim.new(1, 0)
FOV_Corner.Parent = FOV_Circle

local FOV_Stroke = Instance.new("UIStroke")
FOV_Stroke.Thickness = 2
FOV_Stroke.Color = Color3.fromRGB(255, 0, 0)
FOV_Stroke.Parent = FOV_Circle

RunService.RenderStepped:Connect(function()
    FOV_Stroke.Color = CurrentColor
end)

-- [[ MENU ]] --
local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 200, 0, 280)
Menu.Position = UDim2.new(0.03, 0, 0.25, 0)
Menu.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Menu.Active = true
Menu.Draggable = true
Menu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = Menu

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Thickness = 2.5
MenuStroke.Parent = Menu

RunService.RenderStepped:Connect(function()
    MenuStroke.Color = CurrentColor
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Text = "LIWCN ULTIMATE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = CurrentColor
Title.Parent = Menu

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

RunService.RenderStepped:Connect(function()
    Title.TextColor3 = CurrentColor
end)

local function CreateButton(text, y, getConfig, setConfig)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 170, 0, 28)
    Btn.Position = UDim2.new(0.5, -85, 0, y)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Parent = Menu
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    local function Update()
        local enabled = getConfig()
        Btn.Text = text .. (enabled and ": ON" or ": OFF")
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 50, 70)
    end
    Update()
    
    Btn.MouseButton1Click:Connect(function()
        setConfig(not getConfig())
        Update()
    end)
end

-- Nút chức năng (bỏ Fly, Speed)
CreateButton("Aimbot", 45, function() return Settings.Aimbot_Enabled end, function(v) Settings.Aimbot_Enabled = v FOV_Circle.Visible = v end)
CreateButton("ESP", 80, function() return Settings.ESP_Enabled end, function(v) Settings.ESP_Enabled = v end)
CreateButton("Hitbox", 115, function() return Settings.Hitbox_Enabled end, function(v) Settings.Hitbox_Enabled = v end)
CreateButton("Nhặt Tiền", 150, function() return Settings.AutoCollectMoney end, function(v) Settings.AutoCollectMoney = v end)
CreateButton("Auto Cướp", 185, function() return Settings.AutoRob end, function(v) Settings.AutoRob = v end)
CreateButton("Anti AFK", 220, function() return Settings.AntiAfk end, function(v) Settings.AntiAfk = v end)

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

-- [[ ESP ]] --
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
        Stroke.Thickness = 1.5
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
        NameLabel.TextSize = 10
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextStrokeTransparency = 0
        NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        NameLabel.Parent = BoxFrame

        local DistLabel = Instance.new("TextLabel")
        DistLabel.BackgroundTransparency = 1
        DistLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        DistLabel.TextSize = 9
        DistLabel.Font = Enum.Font.GothamBold
        DistLabel.TextStrokeTransparency = 0
        DistLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        DistLabel.Parent = BoxFrame

        gui = { 
            Box = BoxFrame, 
            HealthBg = HealthBg, 
            HealthBar = HealthBar, 
            Name = NameLabel,
            Dist = DistLabel
        }
        ESP_Boxes[model] = gui
    end

    local HeadScreenPos, HeadVisible = Camera:WorldToScreenPoint(Head.Position)
    local RootScreenPos, RootVisible = Camera:WorldToScreenPoint(Root.Position)

    if HeadVisible and RootVisible then
        local Height = math.abs(HeadScreenPos.Y - RootScreenPos.Y)
        local Width = Height / 1.5

        gui.Box.Size = UDim2.new(0, Width, 0, Height)
        gui.Box.Position = UDim2.new(0, HeadScreenPos.X - Width / 2, 0, HeadScreenPos.Y)
        gui.Box.Visible = true

        gui.HealthBg.Size = UDim2.new(0, 2, 1, 0)
        gui.HealthBg.Position = UDim2.new(0, -5, 0, 0)

        local HealthPercent = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
        gui.HealthBar.Size = UDim2.new(1, 0, HealthPercent, 0)
        gui.HealthBar.Position = UDim2.new(0, 0, 1 - HealthPercent, 0)

        gui.Name.Size = UDim2.new(1, 0, 0, 12)
        gui.Name.Position = UDim2.new(0, 0, 0, -14)
        gui.Name.Text = player.Name
        
        local distance = (Root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        gui.Dist.Size = UDim2.new(1, 0, 0, 12)
        gui.Dist.Position = UDim2.new(0, 0, 1, 0)
        gui.Dist.Text = math.floor(distance) .. "m"
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

-- [[ ANTI AFK ]] --
task.spawn(function()
    while task.wait(60) do
        if Settings.AntiAfk then
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end
    end
end)

-- [[ AUTO NHẶT TIỀN + CƯỚP ]] --
local moneyCache = {}
local lastMoneyScan = 0

task.spawn(function()
    while task.wait(0.5) do
        local character = LocalPlayer.Character
        if not character then continue end
        
        local playerRoot = character:FindFirstChild("HumanoidRootPart")
        if not playerRoot then continue end
        
        if Settings.AutoCollectMoney or Settings.AutoRob then
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
                           string.find(parentName, "coin") or string.find(name, "bank") or
                           string.find(name, "vault") or string.find(name, "safe") or
                           string.find(name, "store") or string.find(name, "shop") then
                            table.insert(moneyCache, v)
                        end
                    end
                end
                
                lastMoneyScan = tick()
            end
            
            for _, item in pairs(moneyCache) do
                if item and item.Parent then
                    local distance = (item.Position - playerRoot.Position).Magnitude
                    if distance <= Settings.CollectRadius then
                        if distance > 10 then
                            playerRoot.CFrame = CFrame.new(item.Position + Vector3.new(0, 3, 0))
                        end
                        firetouchinterest(playerRoot, item, 0)
                        firetouchinterest(playerRoot, item, 1)
                        
                        local clickDetector = item:FindFirstChildOfClass("ClickDetector") or (item.Parent and item.Parent:FindFirstChildOfClass("ClickDetector"))
                        if clickDetector then
                            fireclickdetector(clickDetector)
                        end
                        
                        local prompt = item:FindFirstChildOfClass("ProximityPrompt") or (item.Parent and item.Parent:FindFirstChildOfClass("ProximityPrompt"))
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
    Title = "LIWCN ULTIMATE",
    Text = "Đã tải! Aimbot + ESP + Hitbox + Auto Cướp + Anti AFK",
    Duration = 5
})

print("LIWCN ULTIMATE - LOADED!")
