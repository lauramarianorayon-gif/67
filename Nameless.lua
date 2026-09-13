-- =========================================================
-- PLATAFORMA VOLADORA
-- Compatible con ejecución mediante loadstring
-- =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local platform
local enabled = false
local ascending = false
local descending = false
local minimized = false

local SPEED = 35
local FOOT_OFFSET = 3.2

-- =========================================================
-- FUNCIONES
-- =========================================================

local function getCharacter()
	local character = player.Character
	if not character then
		return nil, nil, nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	return character, humanoid, root
end

local function removePlatform()
	if platform then
		platform:Destroy()
		platform = nil
	end
end

local function createPlatform()
	removePlatform()

	local character, humanoid, root = getCharacter()
	if not root or not humanoid then
		return
	end

	platform = Instance.new("Part")
	platform.Name = "FlyingPlatform"
	platform.Size = Vector3.new(6, 0.5, 6)

	platform.Anchored = true
	platform.CanCollide = true
	platform.CanTouch = true
	platform.CanQuery = true

	platform.Material = Enum.Material.Neon
	platform.Color = Color3.fromRGB(50, 255, 70)

	platform.CFrame = CFrame.new(
		root.Position.X,
		root.Position.Y - FOOT_OFFSET,
		root.Position.Z
	)

	platform.Parent = workspace
end

-- =========================================================
-- GUI
-- =========================================================

local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("FlyingPlatformGUI")
if oldGui then
	oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FlyingPlatformGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

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

-- =========================================================
-- VENTANA MOVIBLE
-- =========================================================

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

	if not dragging then
		return
	end

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

-- =========================================================
-- TÍTULO
-- =========================================================

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

-- =========================================================
-- MINIMIZAR
-- =========================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 35, 0, 35)
minimize.Position = UDim2.new(1, -40, 0, 3)
minimize.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 22
minimize.Font = Enum.Font.GothamBold
minimize.Parent = main

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimize

-- =========================================================
-- BOTONES
-- =========================================================

local function createButton(text, y)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1, -20, 0, 48)
	button.Position = UDim2.new(0, 10, 0, y)

	button.BackgroundColor3 = Color3.fromRGB(175, 50, 50)
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 15
	button.Font = Enum.Font.GothamBold

	button.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = button

	return button
end

local platformButton = createButton("PLATAFORMA: OFF", 45)
local upButton = createButton("⬆ ASCENDER: OFF", 100)
local downButton = createButton("⬇ DESCENDER: OFF", 155)

-- =========================================================
-- COLORES
-- =========================================================

local function setButton(button, text, on)

	button.Text = text

	if on then
		button.BackgroundColor3 = Color3.fromRGB(45, 170, 70)
	else
		button.BackgroundColor3 = Color3.fromRGB(175, 50, 50)
	end
end

-- =========================================================
-- PLATAFORMA ON/OFF
-- =========================================================

platformButton.MouseButton1Click:Connect(function()

	enabled = not enabled

	if enabled then

		createPlatform()

		setButton(
			platformButton,
			"PLATAFORMA: ON",
			true
		)

	else

		ascending = false
		descending = false

		removePlatform()

		setButton(
			platformButton,
			"PLATAFORMA: OFF",
			false
		)

		setButton(
			upButton,
			"⬆ ASCENDER: OFF",
			false
		)

		setButton(
			downButton,
			"⬇ DESCENDER: OFF",
			false
		)
	end
end)

-- =========================================================
-- ASCENDER
-- =========================================================

upButton.MouseButton1Click:Connect(function()

	if not enabled then
		return
	end

	ascending = not ascending
	descending = false

	setButton(
		upButton,
		ascending and "⬆ ASCENDER: ON" or "⬆ ASCENDER: OFF",
		ascending
	)

	setButton(
		downButton,
		"⬇ DESCENDER: OFF",
		false
	)
end)

-- =========================================================
-- DESCENDER
-- =========================================================

downButton.MouseButton1Click:Connect(function()

	if not enabled then
		return
	end

	descending = not descending
	ascending = false

	setButton(
		downButton,
		descending and "⬇ DESCENDER: ON" or "⬇ DESCENDER: OFF",
		descending
	)

	setButton(
		upButton,
		"⬆ ASCENDER: OFF",
		false
	)
end)

-- =========================================================
-- MINIMIZAR
-- =========================================================

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

-- =========================================================
-- MOVIMIENTO DE LA PLATAFORMA
-- =========================================================

RunService.Heartbeat:Connect(function(dt)

	if not enabled or not platform then
		return
	end

	local character, humanoid, root = getCharacter()

	if not character or not humanoid or not root then
		return
	end

	if humanoid.Health <= 0 then
		return
	end

	-- =====================================================
	-- ASCENDER / DESCENDER
	-- =====================================================

	if ascending or descending then

		local direction = ascending and 1 or -1
		local movement = SPEED * dt * direction

		-- Mover plataforma
		platform.CFrame =
			platform.CFrame + Vector3.new(0, movement, 0)

		-- Mover personaje exactamente lo mismo
		root.CFrame =
			root.CFrame + Vector3.new(0, movement, 0)

	-- =====================================================
	-- SEGUIMIENTO NORMAL
	-- =====================================================

	else

		-- La plataforma sigue SIEMPRE al HumanoidRootPart.
		-- Esto también funciona cuando el personaje salta.
		local targetPosition = Vector3.new(
			root.Position.X,
			root.Position.Y - FOOT_OFFSET,
			root.Position.Z
		)

		platform.CFrame = CFrame.new(targetPosition)
	end
end)

-- =========================================================
-- RESPAWN
-- =========================================================

player.CharacterAdded:Connect(function()

	task.wait(1)

	if enabled then
		createPlatform()
	end
end)
