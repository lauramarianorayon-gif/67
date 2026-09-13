-- LocalScript
-- StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local platform
local enabled = false
local ascending = false
local descending = false

local SPEED = 35
local FOOT_OFFSET = 3.2

-- =========================
-- CREAR PLATAFORMA
-- =========================

local function createPlatform()
	if platform then
		platform:Destroy()
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then return end

	platform = Instance.new("Part")
	platform.Name = "FlyingPlatform"
	platform.Size = Vector3.new(6, 0.5, 6)

	-- COLISIÓN
	platform.Anchored = true
	platform.CanCollide = true
	platform.CanTouch = true
	platform.CanQuery = true

	platform.Material = Enum.Material.Neon
	platform.Color = Color3.fromRGB(50, 255, 70)

	-- Aparece directamente debajo de los pies
	platform.CFrame = CFrame.new(
		root.Position.X,
		root.Position.Y - FOOT_OFFSET,
		root.Position.Z
	)

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
main.Size = UDim2.new(0, 250, 0, 260)
main.Position = UDim2.new(0.5, -125, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- =========================
-- VENTANA MOVIBLE
-- =========================

local dragging = false
local dragStart
local startPosition

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

-- =========================
-- TÍTULO
-- =========================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🟢 Plataforma Voladora"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- =========================
-- MINIMIZAR
-- =========================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 35, 0, 35)
minimize.Position = UDim2.new(1, -40, 0, 3)
minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 22
minimize.Parent = main

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimize

-- =========================
-- CREAR BOTONES
-- =========================

local function createButton(text, y)
	local b = Instance.new("TextButton")

	b.Size = UDim2.new(1, -20, 0, 48)
	b.Position = UDim2.new(0, 10, 0, y)

	b.BackgroundColor3 = Color3.fromRGB(175, 50, 50)
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 15
	b.Font = Enum.Font.GothamBold

	b.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = b

	return b
end

local platformButton = createButton(
	"PLATAFORMA: OFF",
	45
)

local upButton = createButton(
	"⬆ ASCENDER: OFF",
	100
)

local downButton = createButton(
	"⬇ DESCENDER: OFF",
	155
)

-- =========================
-- PLATAFORMA ON/OFF
-- =========================

platformButton.MouseButton1Click:Connect(function()

	enabled = not enabled

	if enabled then

		createPlatform()

		platformButton.Text = "PLATAFORMA: ON"
		platformButton.BackgroundColor3 =
			Color3.fromRGB(45, 170, 70)

	else

		ascending = false
		descending = false

		removePlatform()

		platformButton.Text = "PLATAFORMA: OFF"
		platformButton.BackgroundColor3 =
			Color3.fromRGB(175, 50, 50)

		upButton.Text = "⬆ ASCENDER: OFF"
		upButton.BackgroundColor3 =
			Color3.fromRGB(175, 50, 50)

		downButton.Text = "⬇ DESCENDER: OFF"
		downButton.BackgroundColor3 =
			Color3.fromRGB(175, 50, 50)
	end
end)

-- =========================
-- ASCENDER
-- =========================

upButton.MouseButton1Click:Connect(function()

	if not enabled then return end

	ascending = not ascending

	if ascending then

		descending = false

		upButton.Text = "⬆ ASCENDER: ON"
		upButton.BackgroundColor3 =
			Color3.fromRGB(45, 170, 70)

		downButton.Text = "⬇ DESCENDER: OFF"
		downButton.BackgroundColor3 =
			Color3.fromRGB(175, 50, 50)

	else

		upButton.Text = "⬆ ASCENDER: OFF"
		upButton.BackgroundColor3 =
			Color3.fromRGB(175, 50, 50)
	end
end)

-- =========================
-- DESCENDER
-- =========================

downButton.MouseButton1Click:Connect(function()

	if not enabled then return end

	descending = not descending

	if descending then

		ascending = false

		downButton.Text = "⬇ DESCENDER: ON"
		downButton.BackgroundColor3 =
			Color3.fromRGB(45, 170, 70)

		upButton.Text = "⬆ ASCENDER: OFF"
		upButton.BackgroundColor3 =
			Color3.fromRGB(175, 50, 50)

	else

		downButton.Text = "⬇ DESCENDER: OFF"
		downButton.BackgroundColor3 =
			Color3.fromRGB(175, 50, 50)
	end
end)

-- =========================
-- MINIMIZAR
-- =========================

local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	platformButton.Visible = not minimized
	upButton.Visible = not minimized
	downButton.Visible = not minimized

	if minimized then

		main.Size = UDim2.new(0, 250, 0, 43)
		minimize.Text = "+"

	else

		main.Size = UDim2.new(0, 250, 0, 260)
		minimize.Text = "—"
	end
end)

-- =========================
-- MOVIMIENTO DE LA PLATAFORMA
-- =========================

RunService.Heartbeat:Connect(function(dt)

	if not enabled or not platform then
		return
	end

	local character = player.Character
	if not character then return end

	local humanoid =
		character:FindFirstChildOfClass("Humanoid")

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		return
	end

	if humanoid.Health <= 0 then
		return
	end

	local currentY = platform.Position.Y
