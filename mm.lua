-- ==============================================================================
-- DELTA HUB - MM2 MOBILE EDITION (CoreGui ESP + WalkSpeed + Auto Coin)
-- ==============================================================================

if not getgenv then
    print("Executor ของคุณไม่รองรับ getgenv")
    return
end

-- ป้องกันการรันซ้ำและเคลียร์ของเก่า
if getgenv().MM2_LoadedUI then
    pcall(function()
        getgenv().MM2_LoadedUI:Destroy()
    end)
end

if getgenv().MM2_Connection then
    getgenv().MM2_Connection:Disconnect()
end

if getgenv().MM2_NoclipConnection then
    getgenv().MM2_NoclipConnection:Disconnect()
end

if getgenv().MM2_CoinConnection then
    getgenv().MM2_CoinConnection:Disconnect()
end

if getgenv().MM2_SpeedConnection then
    getgenv().MM2_SpeedConnection:Disconnect()
end

if getgenv().MM2_PlayerRemoving then
    getgenv().MM2_PlayerRemoving:Disconnect()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ค่าการตั้งค่า (Settings)
local Settings = {
    Noclip = false,
    AutoCoin = false,
    WalkSpeed = false,
    SpeedValue = 27, 
    CoinSpeed = 25   
}

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Mobile_Hub"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end
getgenv().MM2_LoadedUI = ScreenGui

-- โฟลเดอร์เก็บ ESP บนหน้าจอ
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2_ESP_Folder"
ESPFolder.Parent = ScreenGui

-- ปุ่มลอยเปิด/ปิดเมนู
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 52, 0, 52)
FloatingBtn.Position = UDim2.new(0, 30, 0.4, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FloatingBtn.Text = "🔪"
FloatingBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
FloatingBtn.TextSize = 24
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Active = true
FloatingBtn.Draggable = true
FloatingBtn.Parent = ScreenGui

Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(1, 0)
local FloatStroke = Instance.new("UIStroke", FloatingBtn)
FloatStroke.Color = Color3.fromRGB(231, 76, 60)
FloatStroke.Thickness = 2.5

-- หน้าต่างควบคุมสถานะ
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "MM2 MOBILE HUB"
Title.TextColor3 = Color3.fromRGB(231, 76, 60)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 35)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
StatusLabel.Text = "บทบาท: กำลังตรวจสอบ..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Parent = MainFrame

Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 8)

-- ปุ่ม Noclip
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(1, -20, 0, 40)
NoclipBtn.Position = UDim2.new(0, 10, 0, 85)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
NoclipBtn.Text = "Noclip: ปิด ❌"
NoclipBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
NoclipBtn.TextSize = 13
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.Parent = MainFrame
Instance.new("UICorner", NoclipBtn).CornerRadius = UDim.new(0, 8)

NoclipBtn.MouseButton1Click:Connect(function()
    Settings.Noclip = not Settings.Noclip
    if Settings.Noclip then
        NoclipBtn.Text = "Noclip: เปิด ✅"
        NoclipBtn.TextColor3 = Color3.fromRGB(46, 204, 113)
    else
        NoclipBtn.Text = "Noclip: ปิด ❌"
        NoclipBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

-- ปุ่ม WalkSpeed (27)
local OriginalWalkSpeed = 16
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -20, 0, 40)
SpeedBtn.Position = UDim2.new(0, 10, 0, 135)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
SpeedBtn.Text = "WalkSpeed (27): ปิด ❌"
SpeedBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
SpeedBtn.TextSize = 13
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.Parent = MainFrame
Instance.new("UICorner", SpeedBtn).CornerRadius = UDim.new(0, 8)

SpeedBtn.MouseButton1Click:Connect(function()
    Settings.WalkSpeed = not Settings.WalkSpeed
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChild("Humanoid")

    if Settings.WalkSpeed then
        SpeedBtn.Text = "WalkSpeed (27): เปิด ✅"
        SpeedBtn.TextColor3 = Color3.fromRGB(46, 204, 113)
        if humanoid then
            OriginalWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = Settings.SpeedValue
        end
    else
        SpeedBtn.Text = "WalkSpeed (27): ปิด ❌"
        SpeedBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
        if humanoid then
            humanoid.WalkSpeed = OriginalWalkSpeed
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Settings.WalkSpeed = false
    SpeedBtn.Text = "WalkSpeed (27): ปิด ❌"
    SpeedBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
end)

-- ปุ่ม Auto Coin
local CoinBtn = Instance.new("TextButton")
CoinBtn.Size = UDim2.new(1, -20, 0, 40)
CoinBtn.Position = UDim2.new(0, 10, 0, 185)
CoinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
CoinBtn.Text = "Auto Coin: ปิด ❌"
CoinBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
CoinBtn.TextSize = 13
CoinBtn.Font = Enum.Font.GothamBold
CoinBtn.Parent = MainFrame
Instance.new("UICorner", CoinBtn).CornerRadius = UDim.new(0, 8)

CoinBtn.MouseButton1Click:Connect(function()
    Settings.AutoCoin = not Settings.AutoCoin
    if Settings.AutoCoin then
        CoinBtn.Text = "Auto Coin: เปิด ✅"
        CoinBtn.TextColor3 = Color3.fromRGB(46, 204, 113)
    else
        CoinBtn.Text = "Auto Coin: ปิด ❌"
        CoinBtn.TextColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

-- ควบคุมเปิด/ปิด UI ด้วยปุ่มลอย
local uiVisible = true
FloatingBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
end)

-- ระบบแคชบทบาท
local RoleCache = {}
local function UpdatePlayerRole(player)
    local char = player.Character
    if not char then return "Innocent" end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return "Innocent" end

    local function checkContainer(container)
        if not container then return nil end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local itemName = item.Name:lower()
                if itemName == "knife" or itemName:find("knife") or itemName:find("blade") then
                    return "Murderer"
                elseif itemName == "gun" or itemName == "revolver" then
                    return "Sheriff"
                end
            end
        end
        return nil
    end

    local role = checkContainer(char)
    if role then return role end

    if player:FindFirstChild("Backpack") then
        role = checkContainer(player.Backpack)
        if role then return role end
    end
    
    return "Innocent"
end

for _, p in ipairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function() RoleCache[p] = UpdatePlayerRole(p) end)
    if p.Character then RoleCache[p] = UpdatePlayerRole(p) end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() RoleCache[p] = UpdatePlayerRole(p) end)
end)

-- ระบบ Noclip
getgenv().MM2_NoclipConnection = RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    if Settings.Noclip or Settings.AutoCoin then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ระบบ WalkSpeed
getgenv().MM2_SpeedConnection = RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health > 0 and Settings.WalkSpeed then
        humanoid.WalkSpeed = Settings.SpeedValue
    end
end)

-- ระบบ Auto Coin (บินเก็บเหรียญ)
local processedCoins = {}
local isFlyingToCoin = false
LocalPlayer.CharacterAdded:Connect(function()
    table.clear(processedCoins)
    isFlyingToCoin = false
end)

getgenv().MM2_CoinConnection = RunService.Heartbeat:Connect(function()
    if not Settings.AutoCoin or isFlyingToCoin then return end
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 or not hrp then return end

    local coinContainer = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("CoinContainer")
    if not coinContainer then
        for _, v in ipairs(Workspace:GetChildren()) do
            if v:FindFirstChild("CoinContainer") then coinContainer = v.CoinContainer break end
        end
    end

    if coinContainer then
        local coinChildren = coinContainer:GetChildren()
        if #coinChildren == 0 then table.clear(processedCoins) return end

        local closestCoin = nil
        local shortestDist = math.huge
        for _, coin in ipairs(coinChildren) do
            if (coin.Name == "Coin" or coin:FindFirstChild("CoinVisual")) and not processedCoins[coin] then
                local coinPart = coin:IsA("BasePart") and coin or coin:FindFirstChildWhichIsA("BasePart")
                if coinPart then
                    local dist = (hrp.Position - coinPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestCoin = coin
                    end
                end
            end
        end

        if closestCoin then
            local coinPart = closestCoin:IsA("BasePart") and closestCoin or closestCoin:FindFirstChildWhichIsA("BasePart")
            if coinPart then
                processedCoins[closestCoin] = true
                isFlyingToCoin = true
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if not Settings.AutoCoin or not coinPart.Parent or not hrp or not humanoid or humanoid.Health <= 0 then
                        if connection then connection:Disconnect() end
                        isFlyingToCoin = false
                        return
                    end
                    local dir = (coinPart.Position - hrp.Position)
                    if dir.Magnitude < 3 then
                        if connection then connection:Disconnect() end
                        humanoid:Move(Vector3.new(0, 0, 0))
                        isFlyingToCoin = false
                    else
                        hrp.Velocity = dir.Unit * Settings.CoinSpeed
                        humanoid:Move(dir.Unit)
                    end
                end)
            end
        end
    end
end)

print("MM2 Mobile Hub Loaded Successfully!")
