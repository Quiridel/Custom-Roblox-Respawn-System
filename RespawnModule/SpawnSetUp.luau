--!strict
local WorkSpace = game:GetService("Workspace")
local Teams = game:GetService("Teams")

local LocalSpawns = {}
local SpawnSetUp = {}

function SpawnSetUp.SetUpSpawns()
	local function RegisterSpawn(Spawn: SpawnLocation)
		if not LocalSpawns[Spawn] then
			LocalSpawns[Spawn] = {
				Enabled = Spawn.Enabled,
				AllowTeamChangeOnTouch = Spawn.AllowTeamChangeOnTouch,
				TeamColor = Spawn.TeamColor,
				Neutral = Spawn.Neutral,
				Duration = Spawn.Duration,
				Connected = nil :: RBXScriptConnection?
			}
		end
		
		local Connected = LocalSpawns[Spawn].Connected :: RBXScriptConnection?
		
		if not Connected then
			LocalSpawns[Spawn].Connected = Spawn.Changed:Connect(function(property)
				local PropertyName = property :: "Enabled" | "AllowTeamChangeOnTouch" | "TeamColor" | "Neutral" | "Duration"
				
				LocalSpawns[Spawn][PropertyName] = Spawn[PropertyName]
				
			end)
		end
	end
	
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
	
	local Instances = WorkSpace:GetDescendants()
	
	for _, Instance in ipairs(Instances) do
		if Instance:IsA("SpawnLocation") then
			RegisterSpawn(Instance)
		end
	end
	
	WorkSpace.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("SpawnLocation") and not LocalSpawns[descendant] then
			RegisterSpawn(descendant)
		end
	end)
	
	WorkSpace.DescendantRemoving:Connect(function(descendant)
		if descendant:IsA("SpawnLocation") and LocalSpawns[descendant] then
			RemoveSpawn(descendant)
		end
	end)
end

function SpawnSetUp.GetAllSpawns()
	return LocalSpawns
end

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

function SpawnSetUp.GetUniversalSpawns()
	local NeutralSpawns = {}
	for Spawn, SpawnData in LocalSpawns do
		if SpawnData.Neutral == true and SpawnData.Enabled == true then
			table.insert(NeutralSpawns, Spawn)
		end
	end
	return NeutralSpawns
end

function SpawnSetUp.GetAllAvailableSpawnsForPlayer(Player: Player)
	local AllAvailableSpawns = {}
	local Team = Player.Team :: Team?
	if Team then
		for Spawn, SpawnData in LocalSpawns do
			if SpawnData.TeamColor == Team.TeamColor and SpawnData.Enabled or SpawnData.Neutral == true and SpawnData.Enabled == true then
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

return SpawnSetUp