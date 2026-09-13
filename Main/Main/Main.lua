local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plataforma = script.Parent
local HEIGHT = 3.2          -- Altura sobre los pies
local SUAVIDAD = 0.22       -- Qué tan suave sigue (más bajo = más suave)

local dueño = nil
local conexion = nil

local function pegarAJugador(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	dueño = player
	plataforma.Anchored = false

	conexion = RunService.Heartbeat:Connect(function()
		if not character or not character.Parent or humanoid.Health <= 0 then
			soltar()
			return
		end

		-- Posición debajo de los pies + misma dirección del jugador
		local target = hrp.CFrame * CFrame.new(0, -HEIGHT, 0)
		plataforma.CFrame = plataforma.CFrame:Lerp(target, SUAVIDAD)
	end)

	humanoid.Died:Connect(soltar)
end

function soltar()
	if conexion then
		conexion:Disconnect()
		conexion = nil
	end
	dueño = nil
	plataforma.Anchored = true
end

-- Tocar la plataforma para reclamarla
plataforma.Touched:Connect(function(hit)
	local player = Players:GetPlayerFromCharacter(hit.Parent)
	if player and not dueño then
		pegarAJugador(player)
	end
end)

-- RemoteEvent para controlar desde la UI
local remote = Instance.new("RemoteEvent")
remote.Name = "ControlPlataforma"
remote.Parent = plataforma

remote.OnServerEvent:Connect(function(player)
	if not dueño then
		pegarAJugador(player)
	elseif dueño == player then
		soltar()
	end
end)

print("Plataforma verde lista!")
