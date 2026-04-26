-- AUTO ATIRAR + AUTO ESPADA + AUTO EQUIPAR + RESPAWN + NÃO PEGA MORTO

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Ativo = false

-- 🔥 CONFIG
local SPAM_RATE = 1

-- 🔥 DONO
local OWNER_ID = 4687112195

-- 🔥 REMOTES
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShootGun = Remotes:WaitForChild("ShootGun")
local ThrowStart = Remotes:WaitForChild("ThrowStart")
local ThrowHit = Remotes:WaitForChild("ThrowHit")

-- EQUIPAR ITEM 1 E 2
local function EquipItems()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if not backpack or not character then return end

    local tools = {}

    for _, v in pairs(backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(tools, v)
        end
    end

    table.sort(tools, function(a, b)
        return a.Name < b.Name
    end)

    if tools[1] then tools[1].Parent = character end
    if tools[2] then tools[2].Parent = character end
end

-- RESPAWN
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Ativo then
        EquipItems()
    end
end)

-- CHECAR TIME
local function IsEnemy(player)
    if not player.Team or not LocalPlayer.Team then
        return true
    end
    return player.Team ~= LocalPlayer.Team
end

-- PLAYER MAIS PERTO
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge

    local myChar = LocalPlayer.Character
    if not myChar then return end

    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local myPos = myHRP.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and IsEnemy(player) then
            
            local char = player.Character
            local hum = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 0 and char:IsDescendantOf(workspace) then
                local dist = (hrp.Position - myPos).Magnitude

                if dist < shortestDistance then
                    shortestDistance = dist
                    closest = player
                end
            end
        end
    end

    return closest
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
pcall(function() ScreenGui.Parent = game.CoreGui end)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 180)
Frame.Position = UDim2.new(0.5, -120, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "AUTO AIM PRO"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.9, 0, 0, 50)
Button.Position = UDim2.new(0.05, 0, 0.3, 0)
Button.Text = "DESATIVADO"
Button.TextColor3 = Color3.new(1,1,1)
Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Instance.new("UICorner", Button)

-- TEXTO SPAM
local SpamText = Instance.new("TextLabel", Frame)
SpamText.Size = UDim2.new(1, 0, 0, 25)
SpamText.Position = UDim2.new(0, 0, 0.65, 0)
SpamText.Text = "SPAM: "..SPAM_RATE
SpamText.TextColor3 = Color3.new(1,1,1)
SpamText.BackgroundTransparency = 1
SpamText.Font = Enum.Font.GothamBold
SpamText.TextSize = 14

-- +
local Plus = Instance.new("TextButton", Frame)
Plus.Size = UDim2.new(0.4, 0, 0, 30)
Plus.Position = UDim2.new(0.55, 0, 0.8, 0)
Plus.Text = "+"
Plus.TextColor3 = Color3.new(1,1,1)
Plus.BackgroundColor3 = Color3.fromRGB(0,170,0)
Instance.new("UICorner", Plus)

-- -
local Minus = Instance.new("TextButton", Frame)
Minus.Size = UDim2.new(0.4, 0, 0, 30)
Minus.Position = UDim2.new(0.05, 0, 0.8, 0)
Minus.Text = "-"
Minus.TextColor3 = Color3.new(1,1,1)
Minus.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner", Minus)

Plus.MouseButton1Click:Connect(function()
    SPAM_RATE = SPAM_RATE + 1
    SpamText.Text = "SPAM: "..SPAM_RATE
end)

Minus.MouseButton1Click:Connect(function()
    if SPAM_RATE > 1 then
        SPAM_RATE = SPAM_RATE - 1
        SpamText.Text = "SPAM: "..SPAM_RATE
    end
end)

-- BOTÃO
Button.MouseButton1Click:Connect(function()
    Ativo = not Ativo

    if Ativo then
        Button.Text = "ATIVADO"
        Button.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        Button.Text = "DESATIVADO"
        Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    end
end)

-- LOOP
RunService.Heartbeat:Connect(function()
    if not Ativo then return end

    EquipItems()

    local myChar = LocalPlayer.Character
    if not myChar then return end

    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local target = GetClosestPlayer()
    if not target then return end

    -- 🔒 PROTEÇÃO DO DONO
    if target.UserId == OWNER_ID then
        warn("não use no dono!")
        return
    end

    local targetChar = target.Character
    if not targetChar then return end

    local hum = targetChar:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local hitPart = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not hitPart then return end

    local origem = myHRP.Position + Vector3.new(0, 1.5, 0)
    local destino = hitPart.Position
    local direcao = (destino - origem).Unit

    for i = 1, SPAM_RATE do
        ShootGun:FireServer(origem, destino, hitPart, destino)
        ThrowStart:FireServer(origem, direcao)
        ThrowHit:FireServer(hitPart, destino)
    end
end)
