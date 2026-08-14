-- [[ DEVIL ROBBERY HACK - CHICAGO STYLE GAMES ]] --
-- Chuyên dụng: Cướp ngân hàng, cướp đồ, bắn nhau
-- Không có Auto Shoot - Chủ tự bắn, aimbot hỗ trợ khóa mục tiêu

local Settings = {
    -- Aimbot
    Aimbot_Enabled = true,
    FOV_Radius = 250,
    Aimbot_Smoothness = 1,
    Team_Check = false,
    
    -- ESP
    ESP_Enabled = true,
    Box_Color = Color3.fromRGB(255, 255, 255),
    HealthBar_Color = Color3.fromRGB(0, 255, 0),
    
    -- Hitbox
    Hitbox_Enabled = true,
    Hitbox_Size = 15.0,
    Hitbox_Transparency = 0.5,
    
    -- Cướp Ngân Hàng
    AutoRobBank = false,          -- Tự động cướp ngân hàng
    AutoRobStore = false,          -- Tự động cướp cửa hàng
    AutoCollectMoney = true,       -- Tự nhặt tiền sau khi cướp
    AutoEscape = false,            -- Tự chạy thoát sau khi cướp
    RobRadius = 200,               -- Phạm vi tìm mục tiêu cướp
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

-- [[ TẠO GUI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevilRobberyHack"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- [[ HIỆU ỨNG CHỮ 7 MÀU ]] --
local RainbowText = Instance.new("TextLabel")
RainbowText.Size = UDim2.new(0, 600, 0, 50)
RainbowText.Position = UDim2.new(0.5, -300, 0.2, 0)
RainbowText.BackgroundTransparency = 1
RainbowText.Text = "DEVIL ROBBERY HACK"
RainbowText.Font = Enum.Font.GothamBold
RainbowText.TextSize = 36
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

-- [[ VÒNG TRÒN FOV ]] --
local FOV_Circle = Instance.new("Frame")
FOV_Circle.AnchorPoint = Vector2.new(0.5, 0.5)
FOV_Circle.BackgroundTransparency = 1
FOV_Circle.Size = UDim2.new(0, Settings.FOV_Radius * 2, 0, Settings.FOV_Radius * 2)
FOV_Circle.Visible = Settings.Aimbot_Enabled
FOV_Circle.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOV_Circle

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Parent = FOV_Circle

RunService.RenderStepped:Connect(function()
    local Center = Camera.ViewportSize / 2
    local Inset = GuiService:GetGuiInset()
    FOV_Circle.Position = UDim2.new(0, Center.X, 0, Center.Y + Inset.Y / 2)
    UIStroke.Color = CurrentColor
end)

-- [[ MENU ]] --
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 200, 0, 300)
MainMenu.Position = UDim2.new(0.05, 0, 0.25, 0)
MainMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MainMenu

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Thickness = 2
MenuStroke.Parent = MainMenu

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Size = UDim2.new(1, 0, 0, 35)
MenuTitle.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MenuTitle.Text = "  DEVIL ROBBERY"
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextSize = 12
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.Parent = MainMenu

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = MenuTitle

RunService.RenderStepped:Connect(function()
    MenuStroke.Color = CurrentColor
    MenuTitle.TextColor3 = CurrentColor
end)

-- [[ TẠO NÚT ]] --
local function CreateButton(text, yPos, getConfig, setConfig)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 160, 0, 28)
    Button.Position = UDim2.new(0.5, -80, 0, yPos)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 10
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = MainMenu

    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 6)
    BCorner.Parent = Button

    local function UpdateVisual()
        local enabled = getConfig()
        Button.Text = text .. (enabled and ": ON" or ": OFF")
        Button.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 50, 70)
    end
    UpdateVisual()

    Button.MouseButton1Click:Connect(function()
        setConfig(not getConfig())
        UpdateVisual()
    end)
end

-- Sắp xếp nút
CreateButton("Aimbot Khóa Cứng", 48, function() return Settings.Aimbot_Enabled end, function(val) Settings.Aimbot_Enabled = val FOV_Circle.Visible = val end)
CreateButton("Hitbox Tối Thượng", 84, function() return Settings.Hitbox_Enabled end, function(val) Settings.Hitbox_Enabled = val end)
CreateButton("Hiển Thị ESP", 120, function() return Settings.ESP_Enabled end, function(val) Settings.ESP_Enabled = val end)
CreateButton("Auto Cướp Bank", 156, function() return Settings.AutoRobBank end, function(val) Settings.AutoRobBank = val end)
CreateButton("Auto Cướp Store", 192, function() return Settings.AutoRobStore end, function(val) Settings.AutoRobStore = val end)
CreateButton("Auto Nhặt Tiền", 228, function() return Settings.AutoCollectMoney end, function(val) Settings.AutoCollectMoney = val end)
CreateButton("Auto Chạy Thoát", 264, function() return Settings.AutoEscape end, function(val) Settings.AutoEscape = val end)

-- =========================================================
-- [[ HỆ THỐNG CƯỚP NGÂN HÀNG & CỬA HÀNG ]] --
-- =========================================================
local RobSystem = {}

-- Tìm ngân hàng
function RobSystem:FindBanks()
    local banks = {}
    local keywords = {"bank", "vault", "atm", "safe", "money", "cash", "nganhang"}
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") or v:IsA("MeshPart") then
            local name = string.lower(v.Name)
            local parentName = v.Parent and string.lower(v.Parent.Name) or ""
            
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) or string.find(parentName, keyword) then
                    table.insert(banks, v)
                    break
                end
            end
        end
    end
    
    return banks
end

-- Tìm cửa hàng
function RobSystem:FindStores()
    local stores = {}
    local keywords = {"store", "shop", "market", "register", "counter", "cashier", "cuahang"}
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") or v:IsA("MeshPart") then
            local name = string.lower(v.Name)
            local parentName = v.Parent and string.lower(v.Parent.Name) or ""
            
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) or string.find(parentName, keyword) then
                    table.insert(stores, v)
                    break
                end
            end
        end
    end
    
    return stores
end

-- Tìm tiền rơi ra
function RobSystem:FindDroppedMoney()
    local money = {}
    local keywords = {"money", "cash", "coin", "bill", "dollar", "tien", "banknote", "loot"}
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Size.Magnitude < 10 then
            local name = string.lower(v.Name)
            local parentName = v.Parent and string.lower(v.Parent.Name) or ""
            
            for _, keyword in pairs(keywords) do
                if string.find(name, keyword) or string.find(parentName, keyword) then
                    table.insert(money, v)
                    break
                end
            end
        end
    end
    
    return money
end

-- Tìm ProximityPrompt (dùng để tương tác cướp)
function RobSystem:FindPrompts()
    local prompts = {}
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            table.insert(prompts, v)
        end
    end
    
    return prompts
end

-- Tìm ClickDetector (dùng để click cướp)
function RobSystem:FindClickDetectors()
    local detectors = {}
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ClickDetector") then
            table.insert(detectors, v)
        end
    end
    
    return detectors
end

-- Cướp ngân hàng
function RobSystem:RobBank()
    local playerRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return end
    
    local banks = self:FindBanks()
    
    for _, bank in pairs(banks) do
        local bankPos = nil
        if bank:IsA("BasePart") then
            bankPos = bank.Position
        elseif bank:IsA("Model") then
            local primaryPart = bank.PrimaryPart or bank:FindFirstChild("Main") or bank:FindFirstChild("Base")
            if primaryPart then
                bankPos = primaryPart.Position
            end
        end
        
        if bankPos then
            local distance = (bankPos - playerRoot.Position).Magnitude
            if distance <= Settings.RobRadius then
                -- Dịch chuyển tới ngân hàng
                playerRoot.CFrame = CFrame.new(bankPos + Vector3.new(0, 3, 0))
                
                -- Tương tác với ngân hàng
                local prompts = self:FindPrompts()
                for _, prompt in pairs(prompts) do
                    if prompt.Parent and (prompt.Parent:IsDescendantOf(bank) or bank:IsDescendantOf(prompt.Parent) or (prompt.Parent.Position - bankPos).Magnitude < 20) then
                        fireproximityprompt(prompt)
                    end
                end
                
                -- Click vào ngân hàng
                local detectors = self:FindClickDetectors()
                for _, detector in pairs(detectors) do
                    if detector.Parent and (detector.Parent:IsDescendantOf(bank) or bank:IsDescendantOf(detector.Parent) or (detector.Parent.Position - bankPos).Magnitude < 20) then
                        fireclickdetector(detector)
                    end
                end
            end
        end
    end
end

-- Cướp cửa hàng
function RobSystem:RobStore()
    local playerRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return end
    
    local stores = self:FindStores()
    
    for _, store in pairs(stores) do
        local storePos = nil
        if store:IsA("BasePart") then
            storePos = store.Position
        elseif store:IsA("Model") then
            local primaryPart = store.PrimaryPart or store:FindFirstChild("Main") or store:FindFirstChild("Base")
            if primaryPart then
                storePos = primaryPart.Position
            end
        end
        
        if storePos then
            local distance = (storePos - playerRoot.Position).Magnitude
            if distance <= Settings.RobRadius then
                -- Dịch chuyển tới cửa hàng
                playerRoot.CFrame = CFrame.new(storePos + Vector3.new(0, 3, 0))
                
                -- Tương tác với cửa hàng
                local prompts = self:FindPrompts()
                for _, prompt in pairs(prompts) do
                    if prompt.Parent and (prompt.Parent:IsDescendantOf(store) or store:IsDescendantOf(prompt.Parent) or (prompt.Parent.Position - storePos).Magnitude < 20) then
                        fireproximityprompt(prompt)
                    end
                end
                
                -- Click vào cửa hàng
                local detectors = self:FindClickDetectors()
                for _, detector in pairs(detectors) do
                    if detector.Parent and (detector.Parent:IsDescendantOf(store) or store:IsDescendantOf(detector.Parent) or (detector.Parent.Position - storePos).Magnitude < 20) then
                        fireclickdetector(detector)
                    end
                end
            end
        end
    end
end

-- Nhặt tiền
function RobSystem:CollectMoney()
    if not Settings.AutoCollectMoney then return end
    
    local playerRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return end
    
    local moneyItems = self:FindDroppedMoney()
    
    for _, money in pairs(moneyItems) do
        local distance = (money.Position - playerRoot.Position).Magnitude
        if distance <= Settings.RobRadius then
            -- Dịch chuyển tới tiền nếu xa
            if distance > 10 then
                playerRoot.CFrame = CFrame.new(money.Position + Vector3.new(0, 3, 0))
            end
            
            -- Chạm vào tiền
            firetouchinterest(playerRoot, money, 0)
            firetouchinterest(playerRoot, money, 1)
            
            -- Click nếu có ClickDetector
            local detector = money:FindFirstChildOfClass("ClickDetector") or (money.Parent and money.Parent:FindFirstChildOfClass("ClickDetector"))
            if detector then
                fireclickdetector(detector)
            end
        end
    end
end

-- Chạy thoát
function RobSystem:Escape()
    local playerRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return end
    
    -- Tìm vị trí an toàn (xa ngân hàng/cửa hàng)
    local banks = self:FindBanks()
    local stores = self:FindStores()
    
    local escapePos = playerRoot.Position + Vector3.new(0, 0, 50) -- Chạy xa 50 studs
    
    -- Tìm vị trí cao nhất để escape
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local rayResult = workspace:Raycast(
        playerRoot.Position + Vector3.new(0, 50, 0),
        Vector3.new(0, -100, 0),
        rayParams
    )
    
    if rayResult then
        escapePos = rayResult.Position + Vector3.new(0, 5, 0)
    end
    
    playerRoot.CFrame = CFrame.new(escapePos)
end

-- [[ LOOP CƯỚP ]] --
task.spawn(function()
    while true do
        if Settings.AutoRobBank then
            RobSystem:RobBank()
        end
        
        if Settings.AutoRobStore then
            RobSystem:RobStore()
        end
        
        if Settings.AutoCollectMoney then
            RobSystem:CollectMoney()
        end
        
        if Settings.AutoEscape then
            RobSystem:Escape()
        end
        
        task.wait(1)
    end
end)()

-- =========================================================
-- [[ BỘ LỌC KIỂM TRA ĐỐI THỦ ]] --
-- =========================================================
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

-- =========================================================
-- [[ HỆ THỐNG ESP ]] --
-- =========================================================
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

        gui = { Box = BoxFrame, HealthBg = HealthBg, HealthBar = HealthBar, Name = NameLabel }
        ESP_Boxes[model] = gui
    end

    local HeadPos, HeadOnScreen = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
    local LegPos, LegOnScreen = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3, 0))

    if HeadOnScreen and LegOnScreen then
        local Height = math.abs(HeadPos.Y - LegPos.Y)
        local Width = Height / 1.6 
        gui.Box.Size = UDim2.new(0, Width, 0, Height)
        gui.Box.Position = UDim2.new(0, HeadPos.X - Width / 2, 0, HeadPos.Y)
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

-- =========================================================
-- [[ ENGINE XỬ LÝ HITBOX ]] --
-- =========================================================
local CachedTargets = {}
local OriginalSizes = {}

task.spawn(function()
    while task.wait(0.1) do
        local CurrentTargets = {}
        local ScannedModels = {}
        
        for _, player in ipairs(Players:GetPlayers()) do
            if IsValidEnemyPlayer(player) and player.Character then
                local model = player.Character
                local Head, Root, Humanoid = GetCharacterElements(model)
                
                if Head and Root and Humanoid then
                    table.insert(CurrentTargets, {Model = model, Head = Head, Root = Root, Humanoid = Humanoid})
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

-- =========================================================
-- [[ ENGINE KHÓA MỤC TIÊU - KHÔNG AUTO SHOOT ]] --
-- =========================================================
RunService.RenderStepped:Connect(function()
    local Center = Camera.ViewportSize / 2
    local Inset = GuiService:GetGuiInset()
    local ScreenCenter = Vector2.new(Center.X, Center.Y + Inset.Y / 2)
    
    local ClosestTargetHead = nil
    local MaxDistance = Settings.FOV_Radius
    local ActiveModels = {}

    for _, target in ipairs(CachedTargets) do
        local model = target.Model
        local Head = target.Head
        local Root = target.Root
        local Humanoid = target.Humanoid
        
        if model.Parent and Humanoid.Health > 0 then
            ActiveModels[model] = true
            UpdateESP(Players:GetPlayerFromCharacter(model), Head, Root, Humanoid)
            
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
    
    -- Khóa camera vào mục tiêu gần nhất (KHÔNG tự bắn)
    if Settings.Aimbot_Enabled and ClosestTargetHead and LocalPlayer.Character then
        local TargetCFrame = CFrame.lookAt(Camera.CFrame.Position, ClosestTargetHead.Position)
        if Settings.Aimbot_Smoothness >= 1 then
            Camera.CFrame = TargetCFrame
        else
            Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, Settings.Aimbot_Smoothness)
        end
    end
    
    -- Dọn dẹp ESP
    for model, gui in pairs(ESP_Boxes) do
        if not ActiveModels[model] or not Settings.ESP_Enabled then
            gui.Box:Destroy()
            ESP_Boxes[model] = nil
        end
    end
end)

-- [[ THÔNG BÁO HOÀN TẤT ]] --
game.StarterGui:SetCore("SendNotification", {
    Title = "DEVIL ROBBERY HACK",
    Text = "Đã tải xong! Aimbot + ESP + Hitbox + Auto Cướp Bank/Store",
    Duration = 5
})

print("DEVIL ROBBERY HACK - CHICAGO STYLE - LOADED!")
print("Features: Aimbot, ESP, Hitbox, Auto Rob Bank, Auto Rob Store, Auto Collect Money")
print("Chủ tự bắn - Aimbot chỉ khóa mục tiêu!")
