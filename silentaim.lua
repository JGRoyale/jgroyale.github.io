-- Silent Aim propio para BlockSpin

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local FOV = 180
local TeamCheck = true
local WallCheck = false
local Prediction = 0.135

local function isVisible(targetPart)
	if not WallCheck then return true end
	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin)
	local ray = Ray.new(origin, direction)
	local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, targetPart.Parent})
	return hit == nil or hit:IsDescendantOf(targetPart.Parent)
end

local function getClosest()
	local closest = nil
	local shortest = FOV
	local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
	local myTeam = LocalPlayer.Team

	for _, player in pairs(Players:GetPlayers()) do
		if player \~= LocalPlayer and player.Character then
			if TeamCheck and player.Team and player.Team == myTeam then
				continue
			end

			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			local head = player.Character:FindFirstChild("Head")
			local root = player.Character:FindFirstChild("HumanoidRootPart")

			if humanoid and humanoid.Health > 0 and head and root then
				local velocity = root.AssemblyLinearVelocity or Vector3.zero
				local predicted = head.Position + (velocity * Prediction)

				local screenPos, onScreen = Camera:WorldToViewportPoint(predicted)
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
					if dist < shortest and isVisible(head) then
						shortest = dist
						closest = predicted
					end
				end
			end
		end
	end
	return closest
end

local holding = false

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		holding = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		holding = false
	end
end)

RunService.RenderStepped:Connect(function()
	if not holding then return end

	local target = getClosest()
	if target then
		local current = Camera.CFrame
		local goal = CFrame.lookAt(current.Position, target)
		Camera.CFrame = current:Lerp(goal, 0.65)
	end
end)

print("Silent Aim cargado desde GitHub")
