local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = script.Parent
local hum = char:WaitForChild("Humanoid")

-- TOGGLES
local UnlockTorso = true
local UnlockHead = true
local InfiniteStamina = true

-- Neck y Waist
local head = char:WaitForChild("Head")
local torso = char:FindFirstChild("UpperTorso")

local neck = head:FindFirstChild("Neck")
local waist = torso and torso:FindFirstChild("Waist")

RunService.RenderStepped:Connect(function()
	if UnlockHead and neck then
		neck.MaxVelocity = 1
	end

	if UnlockTorso and waist then
		waist.MaxVelocity = 1
	end

	if InfiniteStamina then
		hum:SetAttribute("Stamina", 100)
	end
end)
