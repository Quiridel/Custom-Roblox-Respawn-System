--!strict
--Import Main Systems
local Players = game:GetService("Players")
local WorkSpace = game:GetService("Workspace")
local StarterPlayer = game:GetService("StarterPlayer")
local HealthRegenScript = script.Parent:FindFirstChild("Resources"):FindFirstChild("Health")
local StarterCharacterScripts = StarterPlayer:FindFirstChild("StarterCharacterScripts")
local RigType = Enum.HumanoidRigType.R15 -- PLEASE I BEG YOU TO PUT YOUR CURRENT RIGTYPE STABLISHED IN THE AVATAR SETTINGS
local LocalSpawns = require(script.Parent:FindFirstChild("SpawnSetUp"))
local TimeToRespawn = Players.RespawnTime

--General StarterPlayer Settings (Updated Dinamically)
local StarterPlayerSettings = {
	HealthDisplayDistance = StarterPlayer.HealthDisplayDistance,
	AutoJumpEnabled = StarterPlayer.AutoJumpEnabled,
	NameDisplayDistance = StarterPlayer.NameDisplayDistance,
	CharacterBreakJointsOnDeath = StarterPlayer.CharacterBreakJointsOnDeath,
	CharacterMaxSlopeAngle = StarterPlayer.CharacterMaxSlopeAngle,
	CharacterWalkSpeed = StarterPlayer.CharacterWalkSpeed,
	LoadCharacterAppearance = StarterPlayer.LoadCharacterAppearance,
	UserEmotesEnabled = StarterPlayer.UserEmotesEnabled
}

--Character Jump Configuration
local CharacterUseJumpPower = StarterPlayer.CharacterUseJumpPower
local CharacterJumpPower = StarterPlayer.CharacterJumpPower
local CharacterJumpHeight = StarterPlayer.CharacterJumpHeight

StarterPlayer.Changed:Connect(function(property)
	if property == "HealthDisplayDistance" or property ==  "NameDisplayDistance" or property == "AutoJumpEnabled" or property == "CharacterBreakJointsOnDeath" or property == "CharacterMaxSlopeAngle" or property == "CharacterWalkSpeed" or property == "LoadCharacterAppearance" or property == "UserEmotesEnabled" then
	StarterPlayerSettings[property] = StarterPlayer[property]
	else
		if property == "CharacterUseJumpPower" then
			CharacterUseJumpPower = StarterPlayer.CharacterUseJumpPower
		end
		if property == "CharacterJumpHeight" and not CharacterUseJumpPower then
			CharacterJumpHeight = StarterPlayer.CharacterJumpHeight
		end
		if property == "CharacterJumpPower" and CharacterUseJumpPower then
			CharacterJumpPower = StarterPlayer.CharacterJumpPower
		end
	end
end)

Players.Changed:Connect(function(property)
	if property == "RespawnTime" then
		TimeToRespawn = Players.RespawnTime
	end
end)

local PlayerRespawnReplication = {}

local function PreLoadCharacter(Player: Player)
	local UserID = Player.UserId
	Player.CanLoadCharacterAppearance = StarterPlayerSettings.LoadCharacterAppearance
	local HumanoidDesc = Players:GetHumanoidDescriptionFromUserIdAsync(UserID)
	HumanoidDesc.UseAvatarSettings = true
	local Character = Players:CreateHumanoidModelFromDescriptionAsync(HumanoidDesc, RigType)
	Character.Name = Player.Name
	local NewHealthScript = HealthRegenScript:Clone()
	NewHealthScript.Parent = Character
	local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid
	
	--Configure the Character
	Humanoid.DisplayName = Player.DisplayName
	Humanoid.AutoJumpEnabled = StarterPlayerSettings.AutoJumpEnabled
	Humanoid.WalkSpeed = StarterPlayerSettings.CharacterWalkSpeed
	Humanoid.HealthDisplayDistance = StarterPlayerSettings.HealthDisplayDistance
	Humanoid.NameDisplayDistance = StarterPlayerSettings.NameDisplayDistance
	Humanoid.BreakJointsOnDeath = StarterPlayerSettings.CharacterBreakJointsOnDeath
	Humanoid.MaxSlopeAngle = StarterPlayerSettings.CharacterMaxSlopeAngle
	if CharacterUseJumpPower then
		Humanoid.JumpPower = CharacterJumpPower
	else
		Humanoid.JumpHeight = CharacterJumpHeight
	end
	
	local StarterScripts = StarterCharacterScripts:GetChildren()

	for _, Script in ipairs(StarterScripts) do
		local NewScript = Script:Clone()
		NewScript.Parent = Character
	end
	
	return Character
end

local function LoadCharacter(Character: Model, Player: Player)
	local HRP = Character:WaitForChild("HumanoidRootPart") :: BasePart
	local AvailableSpawns = LocalSpawns.GetAllAvailableSpawnsForPlayer(Player)

	local RandomSpawn = math.random(1, #AvailableSpawns)

	local Spawn = AvailableSpawns[RandomSpawn]
	
	local SpawnSize = Spawn.Size
	local HRPSize = HRP.Size
	
	local Offset = (SpawnSize.Y / 2) + (HRPSize.Y / 2)
	
	HRP.CFrame = Spawn.CFrame * CFrame.new(0, Offset, 0)

	Character.Parent = WorkSpace
	Player.Character = Character
	if Spawn.Duration >= 1 then
		local FF = Instance.new("ForceField")
		FF.Visible = true
		FF.Parent = Character
	end
	task.delay(Spawn.Duration, function()
		Character:FindFirstChild("ForceField"):Destroy()
	end)
end

local function LoadStarterCharacter(Player: Player)
	local Character = PreLoadCharacter(Player)
	local HRP = Character:WaitForChild("HumanoidRootPart") :: BasePart
	local AvailableSpawns = LocalSpawns.GetAllAvailableSpawnsForPlayer(Player)

	local RandomSpawn = math.random(1, #AvailableSpawns)

	local Spawn = AvailableSpawns[RandomSpawn]

	local SpawnSize = Spawn.Size
	local HRPSize = HRP.Size
	
	local Offset = (SpawnSize.Y / 2) + (HRPSize.Y / 2)

	HRP.CFrame = Spawn.CFrame * CFrame.new(0, Offset, 0)

	Character.Parent = WorkSpace
	Player.Character = Character
	if Spawn.Duration >= 1 then
		local FF = Instance.new("ForceField")
		FF.Visible = true
		FF.Parent = Character
	end
	task.delay(Spawn.Duration, function()
		Character:FindFirstChild("ForceField"):Destroy()
	end)
end

function PlayerRespawnReplication.SetUpRespawn(Player: Player)
	Player.CharacterAdded:Connect(function(character)
		local Human = character:WaitForChild("Humanoid") :: Humanoid
		local function ListenForDeath(Humanoid: Humanoid)
			Humanoid.Died:Connect(function()
				local Character = PreLoadCharacter(Player)
				task.delay(TimeToRespawn, function()
					LoadCharacter(Character, Player)
				end)
			end)
		end
		ListenForDeath(Human)
	end)
	
	LoadStarterCharacter(Player)
end

return PlayerRespawnReplication