--!strict
--[[
This is basically a functional but not totally finished Module for registering
custom collision groups, i already configured 2
hope this is useful to you

By Estebanjesus4

V1.1.0
]]

--Imports PhysicsService
local PhysicsService = game:GetService("PhysicsService")

--Name of Mains CollisionGroups (Add any custom collision groups here)
--[[
Example:
local RegisterCollisionGroups = {
	"CollideAgainstPlayers",
	"CantCollideAgainstPlayers",
	"RobloxHatesThisCollisionGroup",
	"⠀⠀⠀⠀⠀⠀⠀⠀⣀⡰⠶⠶⠶⠆⠉⠀⠈⠀⠉⠲⢶⣀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⠴⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⣀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣴⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠦⠄⣀⠀⠀
⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣤⡏⠀⠀⠀
⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠣⣄⡀
⠀⠀⢨⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠃⣀⡄⠀⠀⠀⠀⠀⢸⡷
⠀⠀⠐⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡂⠀⠴⠿⠇⠀⠀⠀⠀⠀⠈⢻
⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠠⠀⢐⠀⠐⠒⣠⣿⣇⠀⢐⡒⡂⠀⠀⠀⠰⢆⡴⠿
⠀⠀⠀⠆⠀⠀⠀⠀⠀⢰⣥⣴⡞⠀⣠⣾⣿⣿⣿⣤⣤⣤⣷⣤⡀⠀⠠⠘⠁⠀
⠀⠀⣀⠀⠀⠀⠀⠀⠀⠈⣻⣿⣷⡾⠟⢹⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀
⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣇⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⠀⠀
⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⠀⠰⣶⡆⢻⣿⣿⡏⣻⡟⢻⣿⣿⡆⠀
⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣦⠀⠙⢷⣦⠹⠇⣶⡌⠛⠛⣿⣷⢾⠟⠻⠃⠀
⡀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣷⣦⠀⠉⠓⠢⣭⢥⣭⣥⣬⢭⡰⠂⠀⠀⠀
⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠐⢠⠀⠀
⢃⡀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢀⡘⠀⠀
⠈⠹⠑⢆⣠⡷⢀⣀⠀⠀⠰⡀⠀⠀⠀⠀⠀⣦⠰⣿⣀⠒⢡⣄⠶⠶⠁⠀⠀⠀" --Yeah bro i love Susies Collision Group
}
]]

local RegisterCollisionGroups = {
	"CollideAgainstPlayers",
	"CantCollideAgainstPlayers",
}

--Here are defined properties to use with RegisterCollisionGroup()
--[[
Example:
local CollisionGroupsProperties = {

	CollideAgainstPlayers = {
		Group1 = "CollideAgainstPlayers",
		Group2 = "CollideAgainstPlayers",
		CollisionState = true
	},
	
	CantCollideAgainstPlayers = {
		Group1 = "CantCollideAgainstPlayers",
		Group2 = "CantCollideAgainstPlayers",
		CollisionState = false
	},
	
	RobloxHatesThisCollisionGroup = {
		Group1 = "AnyOtherCollisiongroup",
		Group2 = "EvilCollisionGroup"
		CollisionState = true/false -- this defines if the collision groups will collide
	},
	
	Susie = {
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	⠄⢄⠀⣤⡠⢄⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣴⣶⣶⣶⣶⠤⣤⣄⡀⠀⠀⠀⠀⠀⠀-- I Highly suggest NOT to swoon any other collision groups⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀	⠀⠈⠈⠉⠉⠀⠉⠙⠛⠛⠛⠛⠛⠛⠹⠿⠿⠿⠷⠿⠾⠿⠶⠿⠿⠿⠿⠿⠟⠎⠝⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

	}
	
}
]]

local CollisionGroupsProperties = {

	CollideAgainstPlayers = {
		Group1 = "CollideAgainstPlayers",
		Group2 = "CollideAgainstPlayers",
		CollisionState = true
	},
	
	CantCollideAgainstPlayers = {
		Group1 = "CantCollideAgainstPlayers",
		Group2 = "CantCollideAgainstPlayers",
		CollisionState = false
	},
	
}

--This returns and stores the registered Collision Groups
local RegisteredCollisionGroups = {}

local PlayerCollisionGroups = {}


--[[
Registers Collision Groups Configured in PlayerCollisionGroups Module
Idk how thos works welp
]]
function PlayerCollisionGroups.RegisterCollisiongroups()
	--Registers Collision Groups
	for _, Name in RegisterCollisionGroups do
		if not table.find(RegisteredCollisionGroups, Name) then
			PhysicsService:RegisterCollisionGroup(Name)
			table.insert(RegisteredCollisionGroups, Name)
		end
	end
	
	--Some hardcoded Collision groups ;)
	PhysicsService:RegisterCollisionGroup("Spawns")
	PhysicsService:CollisionGroupSetCollidable("Spawns", "Default", true)
	
	--Sets up registered Collision groups
	for _, Name in RegisteredCollisionGroups do
		if CollisionGroupsProperties[Name] then
		PhysicsService:CollisionGroupSetCollidable(CollisionGroupsProperties[Name].Group1, CollisionGroupsProperties[Name].Group2, CollisionGroupsProperties[Name].CollisionState)
		PhysicsService:CollisionGroupSetCollidable(CollisionGroupsProperties[Name].Group1, "Default", true)
		PhysicsService:CollisionGroupSetCollidable(CollisionGroupsProperties[Name].Group1, "Spawns", true)
		end
	end

	--Ignore this, is hardcoded btw
	PhysicsService:CollisionGroupSetCollidable("CantCollideAgainstPlayers", "CollideAgainstPlayers", true)

end

--[[
Probably unuseful function supposed to return registered collisions...
or just use GetRegisteredCollisionGroups()
]]
function PlayerCollisionGroups.GetCollisionGroups()
	return RegisterCollisionGroups
end

return PlayerCollisionGroups