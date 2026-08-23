--!strict
--[[
Sets Up Respawns, Updates Some properties dinamically and Stores The Spawn behaviours

By Estebanjesus4

V1.1.0
]]

--Imports Main Systems
local WorkSpace = game:GetService("Workspace")
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local LocalSpawns = {}
local SpawnSetUp = {}
local CurrentPermanentSpawns = {} --Table Exclusive for use in SetSpawnOnTouch()


--[[
Sets Up Spawns in the server, automatically Updates, add, deletes and configures SpawnLocations
]]
function SpawnSetUp.SetUpSpawns()
	--[[
	Registers Spawns and Stores them
	]]
	
	local function RegisterSpawn(Spawn: SpawnLocation)
		if not LocalSpawns[Spawn] then
			--insert The SpawnLocations and their Properties
			LocalSpawns[Spawn] = {
				Enabled = Spawn.Enabled,
				AllowTeamChangeOnTouch = Spawn.AllowTeamChangeOnTouch,
				TeamColor = Spawn.TeamColor,
				Neutral = Spawn.Neutral,
				Duration = Spawn.Duration, --Actually i dont use this welp
				Connected = nil :: RBXScriptConnection?
			}
		end
		
		local Connected = LocalSpawns[Spawn].Connected :: RBXScriptConnection?
		
		if not Connected then
			LocalSpawns[Spawn].Connected = Spawn.Changed:Connect(function(property)
				local PropertyName = property :: "Enabled" | "AllowTeamChangeOnTouch" | "TeamColor" | "Neutral" | "Duration"
				
				--This Hears changes of properties on the Spawns and updates their properties
				LocalSpawns[Spawn][PropertyName] = Spawn[PropertyName]
				
			end)
		end
	end
	
	--[[
	This Function Hates Spawn Locations and deletes them in case of destrouing or moving outside the workspace
	]]
	local function RemoveSpawn(Spawn: SpawnLocation)
		if LocalSpawns[Spawn] then
			local Connected = LocalSpawns[Spawn].Connected :: RBXScriptConnection?
			if Connected and Connected.Connected then
				LocalSpawns[Spawn].Connected:Disconnect()
				LocalSpawns[Spawn].Connected = nil
			end
			LocalSpawns[Spawn] = nil
		end
	end
	
	--[[      
	
	 ▄▀▄▀▀▀▀▄▀▄         
	 █        ▀▄      ▄ 
	█  ▀  ▀     ▀▄▄  █ █
	█ ▄ █▀ ▄       ▀▀  █
	█  ▀▀▀▀            █
	█                  █
	█                  █
	 █  ▄▄  ▄▄▄▄  ▄▄  █ 
	 █ ▄▀█ ▄▀  █ ▄▀█ ▄▀ 
	  ▀   ▀     ▀   ▀   
	  
	Who the hell let this dog enter!?
	He should be Making Deltarune Chapter 6
	]]
	
	--Gets the Descendants of the Workspace
	local Instances = WorkSpace:GetDescendants()
	
	--Registers Spawns for existing Spawns
	for _, Instance in ipairs(Instances) do
		if Instance:IsA("SpawnLocation") then
			RegisterSpawn(Instance)
			Instance.CollisionGroup = "Spawns"
		end
	end
	
	--registers new added spawns during runtime
	WorkSpace.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("SpawnLocation") and not LocalSpawns[descendant] then
			RegisterSpawn(descendant)
			descendant.CollisionGroup = "Spawns"
		end
	end)
	
	--Deletes a registered spawn if destroyed or moved
	WorkSpace.DescendantRemoving:Connect(function(descendant)
		if descendant:IsA("SpawnLocation") and LocalSpawns[descendant] then
			RemoveSpawn(descendant)
		end
	end)
end

--[[
Returns All Respawn without any kind of filtering
]]
function SpawnSetUp.GetAllSpawns()
	return LocalSpawns
end


--[[
Returns all the Spawns connected to a certain team
]]
function SpawnSetUp.GetTeamSpawns(Team: Team)
	local TeamSpawns = {}
	local TeamColor = Team.TeamColor
	for Spawn, SpawnData in LocalSpawns do
		if SpawnData.TeamColor == TeamColor and SpawnData.Neutral == false and SpawnData.Enabled == true then
			table.insert(TeamSpawns, Spawn)
		end
	end
	return TeamSpawns
end

--[[
Get All Spawns and returns the ones with Neutral and Enabled
]]
function SpawnSetUp.GetUniversalSpawns()
	local NeutralSpawns = {}
	for Spawn, SpawnData in LocalSpawns do
		if SpawnData.Neutral == true and SpawnData.Enabled == true then
			table.insert(NeutralSpawns, Spawn)
		end
	end
	return NeutralSpawns
end

--[[
Gets all Available spawnspoints for a player and depending in if theplayer has a team or not
Returns spawns mathicng the player team and if are enabled or neutral and enabled ones if not team
]]
function SpawnSetUp.GetAllAvailableSpawnsForPlayer(Player: Player)
	local AllAvailableSpawns = {}
	local Team = Player.Team :: Team?
	if Team then
		for Spawn, SpawnData in LocalSpawns do
			if (SpawnData.TeamColor == Team.TeamColor and SpawnData.Enabled) or (SpawnData.Neutral == true and SpawnData.Enabled == true) then
				table.insert(AllAvailableSpawns, Spawn)
			end
		end
		return AllAvailableSpawns
	else
		for Spawn, SpawnData in LocalSpawns do
			if SpawnData.Neutral == true and SpawnData.Enabled == true then
				table.insert(AllAvailableSpawns, Spawn)
			end
		end
		return AllAvailableSpawns
	end
end

--[[
Basically Sets Spawns on touch to all players if true in PlayerRespawnReplication
Spawns must be Neutral and Enabled
Players cant register team spawns or disabled ones
also Spawns cant be registered if player is dead
]]
function SpawnSetUp.SetSpawnOnTouch(Player: Player, Character: Model)
	
	local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid?

	local CharacterChilds = Character:GetChildren()
		for _, Instance in CharacterChilds do
			if Instance:IsA("BasePart") then
				Instance.Touched:Connect(function(hit)
					if hit:IsA("SpawnLocation") and hit.Neutral == true and Humanoid.Health >= 0.1 then
						if CurrentPermanentSpawns[Player] ~= hit then
							CurrentPermanentSpawns[Player] = hit
						end
					end
				end)
			end
		end
	return CurrentPermanentSpawns[Player]
end

--[[
Gets Permanent Spawns for the Players if SpawnsOnTouch is enabled
]]
function SpawnSetUp.GetPermanentSpawn(Player: Player)
	local SpawnPoint = CurrentPermanentSpawns[Player]
	
	if SpawnPoint then
		return SpawnPoint
	end
end

return SpawnSetUp