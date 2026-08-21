--!strict

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayerCurrentCamera = {}

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