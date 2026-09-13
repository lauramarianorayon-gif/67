-- Plataforma voladora
-- LocalScript -> StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local platform
local platformEnabled = false
local goingUp = false

local HEIGHT_BELOW_FEET = 3
local FOLLOW_SPEED = 12
local UP_SPEED = 35

-- =========================
-- CREAR PLATAFORMA
-- =========================

local function createPlatform()
	if platform then
		platform:Destroy()
	end

	platform = Instance.new("Part")
	platform.Name = "GreenGoblinPlatform"
	platform.Size = Vector3.new(6, 0.5, 6)
	platform.Anchored = true
	platform.CanCollide = true
	platform.Material = Enum.Material.Neon
	platform.Color = Color3.fromRGB(60, 255, 80)
	platform.Parent = workspace
end

local function removePlatform()
	if platform then
		platform:Destroy()
		platform = nil
	end
end

-- =========================
-- INTERFAZ
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "FlyingPlatformGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 155)
main.Position = UDim2.new(0.5, -110, 0.5, -80)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🟢 Plataforma Voladora"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 3)
minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 20
minimize.Parent = main

local platformButton = Instance.new("TextButton")
platformButton.Size = UDim2.new(1, -20, 0, 45)
platformButton.Position = UDim2.new(0, 10, 0, 45)
platformButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
platformButton.Text = "PLATAFORMA: OFF"
platformButton.TextColor3 = Color3.new(1, 1, 1)
platformButton.TextSize = 15
platformButton.Font = Enum.Font.GothamBold
platformButton.Parent = main

local ascentButton = Instance.new("TextButton")
ascentButton.Size = UDim2.new(1, -20, 0, 45)
ascentButton.Position = UDim2.new(0, 10, 0, 95)
ascentButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
ascentButton.Text = "ASCENDER: OFF"
ascentButton.TextColor3 = Color3.new(1, 1, 1)
ascentButton.TextSize = 15
ascentButton.Font = Enum.Font.GothamBold
ascentButton.Parent = main

for _, button in pairs({platformButton, ascentButton, minimize}) do
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 7)
	c.Parent = button
end

-- =========================
-- BOTÓN PLATAFORMA
-- =========================

platformButton.MouseButton1Click:Connect(function()
	platformEnabled = not platformEnabled

	if platformEnabled then
		createPlatform()
		platformButton.Text = "PLATAFORMA: ON"
		platformButton.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
	else
		goingUp = false
		removePlatform()

		platformButton.Text = "PLATAFORMA: OFF"
		platformButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)

		ascentButton.Text = "ASCENDER: OFF"
		ascentButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
	end
end)

-- =========================
-- BOTÓN ASCENDER
-- =========================

ascentButton.MouseButton1Click:Connect(function()
	if not platformEnabled then
		return
	end

	goingUp = not goingUp

	if goingUp then
		ascentButton.Text = "ASCENDER: ON"
		ascentButton.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
	else
		ascentButton.Text = "ASCENDER: OFF"
		ascentButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
	end
end)

-- =========================
-- MINIMIZAR
-- =========================

local minimized = false

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	platformButton.Visible = not minimized
	ascentButton.Visible = not minimized

	if minimized then
		main.Size = UDim2.new(0, 220, 0, 40)
		minimize.Text = "+"
	else
		main.Size = UDim2.new(0, 220, 0, 155)
		minimize.Text = "—"
	end
end)

-- =========================
-- MOVIMIENTO DE LA PLATAFORMA
-- =========================

RunService.Heartbeat:Connect(function(dt)
	if not platformEnabled or not platform then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root or humanoid.Health <= 0 then
		return
	end

	-- Posición deseada debajo de los pies
	local feetY = root.Position.Y - 3

	local targetY

	if goingUp then
		-- La plataforma sube
		targetY = platform.Position.Y + (UP_SPEED * dt)
	else
		-- Se mantiene debajo de los pies
		targetY = feetY - HEIGHT_BELOW_FEET
	end

	-- X/Z siempre regresan debajo del jugador
	local targetPosition = Vector3.new(
		root.Position.X,
		targetY,
		root.Position.Z
	)

	-- Suavizado para que vuelva hacia ti
	local alpha = math.clamp(FOLLOW_SPEED * dt, 0, 1)

	platform.Position = platform.Position:Lerp(
		targetPosition,
		alpha
	)
end)

-- =========================
-- RECREAR AL MORIR
-- =========================

player.CharacterAdded:Connect(function()
	task.wait(1)

	if platformEnabled then
		createPlatform()
	end
end)
