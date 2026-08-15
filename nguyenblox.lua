-- [[ BLOX FRUITS AUTO FARM PRO MAX ]] --
-- Tự farm level, tự nâng skill, tự mua đồ, tự tele đảo mới

local Settings = {
    AutoFarm = true,
    AutoSkill = true,
    AutoBuySword = true,
    AutoBuyItems = true,
    AutoTeleport = true,
    AutoEquipBest = true,
    
    -- Farm Settings
    FarmMode = "Melee", -- Melee/Weapon/Fruit
    SkillMode = "Random", -- Random/Strongest/First
    TargetPriority = "Nearest", -- Nearest/Strongest/Weakest
    
    -- Auto Buy
    BuySword = true,
    BuyGun = true,
    BuyAccessory = true,
    
    -- Teleport
    AutoNextIsland = true,
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

-- [[ GUI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitFarmPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- [[ MÀU 7 MÀU ]] --
local CurrentColor = Color3.fromRGB(255, 255, 255)
RunService.RenderStepped:Connect(function()
    local hue = (tick() % 5) / 5
    CurrentColor = Color3.fromHSV(hue, 1, 1)
end)

-- [[ MENU ]] --
local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(0, 200, 0, 280)
Menu.Position = UDim2.new(0.02, 0, 0.2, 0)
Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Menu.Active = true
Menu.Draggable = true
Menu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 15)
MenuCorner.Parent = Menu

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Thickness = 3
MenuStroke.Parent = Menu

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Text = "BLOX FRUIT FARM"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = Menu

RunService.RenderStepped:Connect(function()
    MenuStroke.Color = CurrentColor
    Title.TextColor3 = CurrentColor
end)

-- [[ NÚT CHỨC NĂNG ]] --
local function CreateButton(text, y, getConfig, setConfig)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 170, 0, 28)
    Btn.Position = UDim2.new(0.5, -85, 0, y)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.AutoButtonColor = false
    Btn.Parent = Menu
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
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

CreateButton("Auto Farm", 45, function() return Settings.AutoFarm end, function(v) Settings.AutoFarm = v end)
CreateButton("Auto Skill", 78, function() return Settings.AutoSkill end, function(v) Settings.AutoSkill = v end)
CreateButton("Auto Mua Kiếm", 111, function() return Settings.BuySword end, function(v) Settings.BuySword = v end)
CreateButton("Auto Mua Đồ", 144, function() return Settings.BuyAccessory end, function(v) Settings.BuyAccessory = v end)
CreateButton("Auto Teleport", 177, function() return Settings.AutoTeleport end, function(v) Settings.AutoTeleport = v end)
CreateButton("Auto Đảo Mới", 210, function() return Settings.AutoNextIsland end, function(v) Settings.AutoNextIsland = v end)

-- [[ HỆ THỐNG FARM LEVEL ]] --
local FarmSystem = {}

-- Lấy level hiện tại
function FarmSystem:GetLevel()
    local level = 0
    pcall(function()
        level = LocalPlayer.Data.Level.Value
    end)
    return level
end

-- Lấy stats
function FarmSystem:GetStats()
    local stats = {
        Melee = 0,
        Defense = 0,
        Sword = 0,
        Gun = 0,
        Fruit = 0
    }
    pcall(function()
        stats.Melee = LocalPlayer.Data.Stats.Melee.Level.Value
        stats.Defense = LocalPlayer.Data.Stats.Defense.Level.Value
        stats.Sword = LocalPlayer.Data.Stats.Sword.Level.Value
        stats.Gun = LocalPlayer.Data.Stats.Gun.Level.Value
        stats.Fruit = LocalPlayer.Data.Stats.Fruit.Level.Value
    end)
    return stats
end

-- Tìm enemy gần nhất
function FarmSystem:FindNearestEnemy()
    local nearest = nil
    local nearestDist = math.huge
    
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local root = v:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = v
                end
            end
        end
    end
    
    return nearest
end

-- Tìm NPC quest
function FarmSystem:FindQuestNPC()
    for _, v in pairs(workspace.NPCs:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local dist = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < 50 then
                return v
            end
        end
    end
    return nil
end

-- Lấy quest
function FarmSystem:GetQuest()
    local questNPC = self:FindQuestNPC()
    if questNPC then
        -- Teleport tới NPC
        LocalPlayer.Character.HumanoidRootPart.CFrame = questNPC.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        -- Click NPC để nhận quest
        wait(0.5)
        -- Tìm ProximityPrompt
        local prompt = questNPC:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            fireproximityprompt(prompt)
        end
    end
end

-- Attack enemy
function FarmSystem:AttackEnemy(enemy)
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    
    if Settings.FarmMode == "Melee" then
        -- Dùng melee
        local attackAnim = humanoid:FindFirstChild("Attack") or humanoid:FindFirstChild("Punch")
        if attackAnim then
            attackAnim:Play()
        end
    elseif Settings.FarmMode == "Weapon" then
        -- Dùng kiếm
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end

-- Nâng cấp skill
function FarmSystem:UpgradeSkill()
    local stats = self:GetStats()
    
    -- Nâng cấp skill thấp nhất
    if Settings.SkillMode == "Random" then
        local skills = {"Melee", "Defense", "Sword", "Gun", "Fruit"}
        local randomSkill = skills[math.random(1, #skills)]
        pcall(function()
            LocalPlayer.Data.Stats[randomSkill].Level.Value = LocalPlayer.Data.Stats[randomSkill].Level.Value + 1
        end)
    end
end

-- Mua kiếm
function FarmSystem:BuySword()
    local shops = workspace.Shops
    if shops then
        for _, shop in pairs(shops:GetChildren()) do
            if shop:FindFirstChild("Swords") then
                -- Teleport tới shop
                LocalPlayer.Character.HumanoidRootPart.CFrame = shop.CFrame * CFrame.new(0, 5, 0)
                wait(1)
                -- Mua kiếm
                local prompt = shop:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end

-- Mua đồ
function FarmSystem:BuyItems()
    local shops = workspace.Shops
    if shops then
        for _, shop in pairs(shops:GetChildren()) do
            if shop:FindFirstChild("Accessories") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = shop.CFrame * CFrame.new(0, 5, 0)
                wait(1)
                local prompt = shop:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end

-- Teleport đảo mới theo level
function FarmSystem:TeleportNextIsland()
    local level = self:GetLevel()
    local islandName = ""
    
    if level >= 1 and level < 10 then
        islandName = "Jungle"
    elseif level >= 10 and level < 25 then
        islandName = "Pirate Village"
    elseif level >= 25 and level < 50 then
        islandName = "Desert"
    elseif level >= 50 and level < 75 then
        islandName = "Frozen Village"
    elseif level >= 75 and level < 100 then
        islandName = "Marine Fortress"
    elseif level >= 100 and level < 150 then
        islandName = "Skylands"
    elseif level >= 150 and level < 200 then
        islandName = "Fishman Island"
    elseif level >= 200 and level < 300 then
        islandName = "Second Sea"
    end
    
    -- Tìm đảo
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == islandName then
            LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot() * CFrame.new(0, 5, 0)
            break
        end
    end
end

-- [[ MAIN FARM LOOP ]] --
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoFarm then
            local character = LocalPlayer.Character
            if not character then continue end
            
            -- Lấy quest nếu chưa có
            FarmSystem:GetQuest()
            
            -- Tìm enemy
            local enemy = FarmSystem:FindNearestEnemy()
            
            if enemy then
                -- Teleport tới enemy
                character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                
                -- Attack
                FarmSystem:AttackEnemy(enemy)
                
                -- Auto skill
                if Settings.AutoSkill then
                    FarmSystem:UpgradeSkill()
                end
            else
                -- Không có enemy -> teleport đảo mới
                if Settings.AutoNextIsland then
                    FarmSystem:TeleportNextIsland()
                end
            end
            
            -- Auto mua đồ
            if Settings.BuySword then
                FarmSystem:BuySword()
            end
            
            if Settings.BuyAccessory then
                FarmSystem:BuyItems()
            end
        end
    end
end)

-- [[ THÔNG BÁO ]] --
game.StarterGui:SetCore("SendNotification", {
    Title = "BLOX FRUIT FARM PRO",
    Text = "Auto Farm + Skill + Mua Đồ + Teleport Đảo Mới!",
    Duration = 5
})

print("BLOX FRUIT FARM PRO - LOADED!")
