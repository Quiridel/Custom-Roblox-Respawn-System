--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local SpawnSetUp = require(script:FindFirstChild("SpawnSetUp"))
local PlayerRespawnReplication = require(script:WaitForChild("PlayerRespawnReplication"))

local RespawnModule = {}

function RespawnModule.Initialize()
	
	if RunService:IsServer() then
		Players.CharacterAutoLoads = false
		SpawnSetUp.SetUpSpawns()
		Players.PlayerAdded:Connect(function(Player)
			PlayerRespawnReplication.SetUpRespawn(Player)
			CollectionService:AddTag(Player, "RespawnReplicationConnected")
		end)
	
		for _, Player in ipairs(Players:GetPlayers()) do
			if not CollectionService:HasTag(Player, "RespawnReplicationConnected") then
				PlayerRespawnReplication.SetUpRespawn(Player)
				CollectionService:AddTag(Player, "RespawnReplicationConnected")
			end
		end
	else
		require(script:FindFirstChild("PlayerCurrentCamera")).SetUpCamera()
	end
end

return RespawnModule