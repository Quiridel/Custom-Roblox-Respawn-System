--!strict
--[[
Custom Respawn System Main Module, this and his childs must be in ReplicatedStorage, this initializes the whole system

By Estebanjesus4

V1.1.0
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local SpawnSetUp = require(script:WaitForChild("SpawnSetUp"))
local PlayerRespawnReplication = require(script:WaitForChild("PlayerRespawnReplication"))
local PlayerCollisionGroups = require(script:WaitForChild("PlayerCollisionGroups"))

local RespawnModule = {}

function RespawnModule.Initialize()
	if RunService:IsServer() then
		Players.CharacterAutoLoads = false --Deactivates Roblox SpawnerService
		PlayerCollisionGroups.RegisterCollisiongroups() --Register Custom Collision Groups
		SpawnSetUp.SetUpSpawns()
		Players.PlayerAdded:Connect(function(Player)
			PlayerRespawnReplication.SetUpRespawn(Player) --Sets Up Respawn for every player
			PlayerRespawnReplication.LoadStarterCharacter(Player) --Loads Character on Join
			CollectionService:AddTag(Player, "RespawnReplicationConnected")
		end)
	
		for _, Player in ipairs(Players:GetPlayers()) do
			if not CollectionService:HasTag(Player, "RespawnReplicationConnected") then
				PlayerRespawnReplication.SetUpRespawn(Player)
				CollectionService:AddTag(Player, "RespawnReplicationConnected")
			end
		end
	else
		require(script:WaitForChild("PlayerCurrentCamera")).SetUpCamera() --Configures Camera on Client
	end
end

return RespawnModule