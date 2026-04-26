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

-- EQUIPAR ITEM
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

-- TIME
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

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and IsEnemy(player) then
			local char = player.Character
			local hum = char:FindFirstChild("Humanoid")
			local hrp = char:FindFirstChild("HumanoidRootPart")

			if hum and hrp and hum.Health > 0 then
				local dist = (hrp.Position - myHRP.Position).Magnitude
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
Frame.Size = UDim2.new(0, 260, 0, 300)
Frame.Position = UDim2.new(0.5, -130, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame)

-- 🔥 BORDA RGB
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 3
FrameStroke.Parent = Frame

task.spawn(function()
	while true do
		for i = 0,1,0.01 do
			FrameStroke.Color = Color3.fromHSV(i,1,1)
			task.wait(0.03)
		end
	end
end)

-- 🔥 BOTÃO X (MINIMIZAR)
local Minimized = false
local OldSize = Frame.Size
local OldPos = Frame.Position

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	if Minimized then
		OldSize = Frame.Size
		OldPos = Frame.Position

		Frame.Size = UDim2.new(0, 60, 0, 60)
		Frame.Position = UDim2.new(0.8, 0, 0.2, 0)

		for _, v in pairs(Frame:GetChildren()) do
			if v ~= CloseBtn and v:IsA("GuiObject") then
				v.Visible = false
			end
		end

		CloseBtn.Text = "+"
		Frame.Draggable = true
	else
		Frame.Size = OldSize
		Frame.Position = OldPos

		for _, v in pairs(Frame:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Visible = true
			end
		end

		CloseBtn.Text = "X"
	end
end)

-- TÍTULO
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "AUTO AIM PRO"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- BOTÃO ATIVAR
local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.9, 0, 0, 40)
Button.Position = UDim2.new(0.05, 0, 0.12, 0)
Button.Text = "DESATIVADO"
Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.GothamBold
Instance.new("UICorner", Button)

-- HITBOX BOTÃO
local HitboxButton = Instance.new("TextButton", Frame)
HitboxButton.Size = UDim2.new(0.9, 0, 0, 40)
HitboxButton.Position = UDim2.new(0.05, 0, 0.28, 0)
HitboxButton.Text = "HITBOX OFF"
HitboxButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
HitboxButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", HitboxButton)

-- HITBOX TEXTO
local HitboxText = Instance.new("TextLabel", Frame)
HitboxText.Size = UDim2.new(1, 0, 0, 20)
HitboxText.Position = UDim2.new(0, 0, 0.42, 0)
HitboxText.Text = "HITBOX: 5"
HitboxText.BackgroundTransparency = 1
HitboxText.TextColor3 = Color3.new(1,1,1)

-- HITBOX + -
local HitboxMinus = Instance.new("TextButton", Frame)
HitboxMinus.Size = UDim2.new(0.4, 0, 0, 30)
HitboxMinus.Position = UDim2.new(0.05, 0, 0.5, 0)
HitboxMinus.Text = "-"
Instance.new("UICorner", HitboxMinus)

local HitboxPlus = Instance.new("TextButton", Frame)
HitboxPlus.Size = UDim2.new(0.4, 0, 0, 30)
HitboxPlus.Position = UDim2.new(0.55, 0, 0.5, 0)
HitboxPlus.Text = "+"
Instance.new("UICorner", HitboxPlus)

-- SPAM TEXTO
local SpamText = Instance.new("TextLabel", Frame)
SpamText.Size = UDim2.new(1, 0, 0, 20)
SpamText.Position = UDim2.new(0, 0, 0.65, 0)
SpamText.Text = "SPAM: 1"
SpamText.BackgroundTransparency = 1
SpamText.TextColor3 = Color3.new(1,1,1)

-- SPAM + -
local Minus = Instance.new("TextButton", Frame)
Minus.Size = UDim2.new(0.4, 0, 0, 30)
Minus.Position = UDim2.new(0.05, 0, 0.73, 0)
Minus.Text = "-"
Instance.new("UICorner", Minus)

local Plus = Instance.new("TextButton", Frame)
Plus.Size = UDim2.new(0.4, 0, 0, 30)
Plus.Position = UDim2.new(0.55, 0, 0.73, 0)
Plus.Text = "+"
Instance.new("UICorner", Plus)

-- VARS
local HitboxAtivo = false
local HITBOX_SIZE = 5

-- BOTÕES
Button.MouseButton1Click:Connect(function()
	Ativo = not Ativo
	Button.Text = Ativo and "ATIVADO" or "DESATIVADO"
	Button.BackgroundColor3 = Ativo and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
end)

HitboxButton.MouseButton1Click:Connect(function()
	HitboxAtivo = not HitboxAtivo
	HitboxButton.Text = HitboxAtivo and "HITBOX ON" or "HITBOX OFF"
end)

Plus.MouseButton1Click:Connect(function()
	SPAM_RATE += 1
	SpamText.Text = "SPAM: "..SPAM_RATE
end)

Minus.MouseButton1Click:Connect(function()
	if SPAM_RATE > 1 then
		SPAM_RATE -= 1
		SpamText.Text = "SPAM: "..SPAM_RATE
	end
end)

HitboxPlus.MouseButton1Click:Connect(function()
	HITBOX_SIZE += 1
	HitboxText.Text = "HITBOX: "..HITBOX_SIZE
end)

HitboxMinus.MouseButton1Click:Connect(function()
	if HITBOX_SIZE > 2 then
		HITBOX_SIZE -= 1
		HitboxText.Text = "HITBOX: "..HITBOX_SIZE
	end
end)

-- 🔥 HITBOX LOOP (1 SEGUNDO)
task.spawn(function()
	while true do
		task.wait(1)

		if HitboxAtivo then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local hrp = player.Character:FindFirstChild("HumanoidRootPart")
					local hum = player.Character:FindFirstChild("Humanoid")

					if hrp and hum and hum.Health > 0 then
						hrp.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
						hrp.Transparency = 0.4
						hrp.Material = Enum.Material.Neon
						hrp.BrickColor = BrickColor.new("Really red")
						hrp.CanCollide = false
					end
				end
			end
		end
	end
end)

-- LOOP ORIGINAL (NÃO MEXI)
RunService.Heartbeat:Connect(function()

	if not Ativo then return end

	EquipItems()

	local myChar = LocalPlayer.Character
	if not myChar then return end

	local myHRP = myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	local target = GetClosestPlayer()
	if not target then return end

	if target.UserId == OWNER_ID then return end

	local targetChar = target.Character
	if not targetChar then return end

	local hum = targetChar:FindFirstChild("Humanoid")
	if not hum or hum.Health <= 0 then return end

	local hitPart = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
	if not hitPart then return end

	local origem = myHRP.Position
	local destino = hitPart.Position
	local direcao = (destino - origem).Unit

	for i = 1, SPAM_RATE do
		ShootGun:FireServer(origem, destino, hitPart, destino)
		ThrowStart:FireServer(origem, direcao)
		ThrowHit:FireServer(hitPart, destino)
	end

end)
