--!strict
--[[
Handles Camera in the client, to prevent bugs and players from seeing their own DisplayNames

By Estebanjesus4

V1.1.0
]]

--Imports Players Service
local Players = game:GetService("Players")

--Gets the LocalPlayer
local LocalPlayer = Players.LocalPlayer

local PlayerCurrentCamera = {}

--[[
Sets up camera and prevent it from bugging
]]
function PlayerCurrentCamera.SetUpCamera()
	LocalPlayer.CharacterAdded:Connect(function(character)
		local Humanoid = character:WaitForChild("Humanoid") :: Humanoid?
		local Camera = workspace.CurrentCamera
		if Humanoid then
			Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			Camera.CameraSubject = Humanoid
		end
	end)
end

return PlayerCurrentCamera