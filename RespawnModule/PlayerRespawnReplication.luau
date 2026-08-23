--!strict
--[[
Basically the heart of my system
Handles Player Respawns and decides how and where will spawn
modify this like you want

By Estebanjesus4

V1.1.0
]]


--Import Main Systems
local Players = game:GetService("Players")
local WorkSpace = game:GetService("Workspace")
local StarterPlayer = game:GetService("StarterPlayer")
local HealthRegenScript = script.Parent:FindFirstChild("Resources"):FindFirstChild("Health")
local StarterCharacterScripts = StarterPlayer:FindFirstChild("StarterCharacterScripts")
local LocalSpawns = require(script.Parent:FindFirstChild("SpawnSetUp"))
local TimeToRespawn = Players.RespawnTime


--This is basically to choose if you want the players to spawn in their last touched spawn
--setting this to true will ignore the Configuration you have in LoadCharacter() and LoadStarterCharacter()
local SpawnsOnTouch = false



local Overrides = require(script.Parent:FindFirstChild("Overrides"))
local PlayerCollisionGroups = require(script.Parent:WaitForChild("PlayerCollisionGroups"))

export type RigType = "R6" | "R15"

--Defines what R6 or R15 means so LUA doesnt start crying
local RigTypesMap = {
	R6 = Enum.HumanoidRigType.R6,
	R15 = Enum.HumanoidRigType.R15,
}


--This wont work until you put here any valid coordinates if you need them
local CustomFallbackPos = CFrame.new(SomeXNumber, SomeYNumber, SomeZNumber) -- You Can Put Here a Custom Position to spawn your character if there is not Existing Spawn in the Workspace

local DefaultFallBackPosIfNotSpawn = CustomFallbackPos or CFrame.new(0, 0, 0) --Else it will spawn at the 0, 0, 0 coordinates

local CollisionGroup = "CollideAgainstPlayers" -- Put here any collision group configured in the PlayerCollisionGroups Module



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


--Detects if Game uses JumpPower or JumpHeight and Configures it
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

--Detects and update the Respawntime for Players if changed from Players Service properties
Players.Changed:Connect(function(property)
	if property == "RespawnTime" then
		TimeToRespawn = Players.RespawnTime
	end
end)

local PlayerRespawnReplication = {}
--[[
Main Function to Preload Characters and having them ready
so with that you have only to put it in the Workspace
]]
local function PreLoadCharacter(Player: Player)
	local UserID = Player.UserId
	Player.CanLoadCharacterAppearance = StarterPlayerSettings.LoadCharacterAppearance
		
	--[[
	Gets the humanoid description from a player to construct it later, protected by a pcall in case of failure
	]]
	local Success, Result = pcall(function()
			return Players:GetHumanoidDescriptionFromUserIdAsync(UserID)
		end)
		
	if not Success then
		print(Result)
		Player:LoadCharacterAsync()
		return
	end
		
	local HumanoidDesc = Result
	HumanoidDesc.UseAvatarSettings = true
		
		
--[[
Here you configure your avatar how you want...
You Really Shouldnt Mix R15 with R6
]]
	local RigType: RigType = "R15" --Put Here the type of Rig you wanna use (R6 or R15)
	local AnimationPreset: string = "PlayersChoose" --Put Here a Animation Preset On Overrides by default or a custom one, also make sure to NOT leave this empty or it will explode
	--local AnimationPreset: string = "PlayersChoose" Means Players Spawn with their own Animation Packs
		
		
	--this help making the R6 and R15 dynamic
	local HumanoidRigType = RigTypesMap[RigType]
	local NewAnims = Overrides.Animations[AnimationPreset]		
	
	--[[
	Creates the Humanoid Model (Or the character) from the humanoid description obtanined before
	if fails, prints the error and lets roblox create the character
	]]
	local success, result = pcall(function()
		return Players:CreateHumanoidModelFromDescriptionAsync(HumanoidDesc, HumanoidRigType)
	end)
	
	if not success then
		print(result)
		Player:LoadCharacterAsync()
		return
	end
	
	local Character = result
	Character.Name = Player.Name
	
	--[[
	Get your chosen presets and bodytypes and applies them
	]]
	if AnimationPreset and AnimationPreset ~= "PlayersChoose" then
		local AnimateScript = Character:WaitForChild("Animate") :: LocalScript?
			

		--[[
		Get Character Animations from the chosen preset and appply them
		]]
		if AnimateScript then
			if RigType == "R15" then
				--[[
				This ones only Applies to R15 Models
				]]
				local IdleAnim1 = AnimateScript:WaitForChild("idle"):WaitForChild("Animation1") :: Animation
				local IdleAnim2 = AnimateScript:WaitForChild("idle"):WaitForChild("Animation2") :: Animation
				local WalkAnim = AnimateScript:WaitForChild("walk"):WaitForChild("WalkAnim") :: Animation
				local JumpAnim = AnimateScript:WaitForChild("jump"):WaitForChild("JumpAnim") :: Animation
				local FallAnim = AnimateScript:WaitForChild("fall"):WaitForChild("FallAnim") :: Animation
				local RunAnim = AnimateScript:WaitForChild("run"):WaitForChild("RunAnim") :: Animation
				local SwimAnim = AnimateScript:WaitForChild("swim"):WaitForChild("Swim") :: Animation
				local SwimIdle = AnimateScript:WaitForChild("swimidle"):WaitForChild("SwimIdle") :: Animation
				local ClimbAnim = AnimateScript:WaitForChild("climb"):WaitForChild("ClimbAnim") :: Animation
				local Sit = AnimateScript:WaitForChild("sit"):WaitForChild("SitAnim") :: Animation
			
				IdleAnim1.AnimationId = "rbxassetid://" .. tostring(NewAnims.IdleAnimation1)
				IdleAnim2.AnimationId = "rbxassetid://" .. tostring(NewAnims.IdleAnimation2)
				WalkAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.WalkAnimation)
				JumpAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.JumpAnimation)
				FallAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.FallAnimation)
				RunAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.RunAnimation)
				SwimAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.SwimAnimation)
				SwimIdle.AnimationId = "rbxassetid://" .. tostring(NewAnims.SwimIdleAnimation)
				ClimbAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.ClimbAnimation)
				Sit.AnimationId = "rbxassetid://" .. tostring(NewAnims.SitAnimation)
			else
				--[[
				And this ones are applied to R6 Models
				]]
				local IdleAnim1 = AnimateScript:WaitForChild("idle"):WaitForChild("Animation1") :: Animation
				local IdleAnim2 = AnimateScript:WaitForChild("idle"):WaitForChild("Animation2") :: Animation
				local WalkAnim = AnimateScript:WaitForChild("walk"):WaitForChild("WalkAnim") :: Animation
				local JumpAnim = AnimateScript:WaitForChild("jump"):WaitForChild("JumpAnim") :: Animation
				local FallAnim = AnimateScript:WaitForChild("fall"):WaitForChild("FallAnim") :: Animation
				local ClimbAnim = AnimateScript:WaitForChild("climb"):WaitForChild("ClimbAnim") :: Animation
				local Sit = AnimateScript:WaitForChild("sit"):WaitForChild("SitAnim") :: Animation
						
				IdleAnim1.AnimationId = "rbxassetid://" .. tostring(NewAnims.IdleAnimation1)
				IdleAnim2.AnimationId = "rbxassetid://" .. tostring(NewAnims.IdleAnimation2)
				WalkAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.WalkAnimation)
				JumpAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.JumpAnimation)
				FallAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.FallAnimation)
				ClimbAnim.AnimationId = "rbxassetid://" .. tostring(NewAnims.ClimbAnimation)
				Sit.AnimationId = "rbxassetid://" .. tostring(NewAnims.SitAnimation)
			end
		end
	end
		
		
	--[[
	Clones the Vanilla Health regen Script to the models
	]]
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


	--[[
	Clones StarterCharacterScripts to the models in case you have
	]]
	local StarterScripts = StarterCharacterScripts:GetChildren()
	if #StarterScripts >= 1 then
		for _, Script in ipairs(StarterScripts) do
			local NewScript = Script:Clone()
			NewScript.Parent = Character
		end
	end

	return Character
end


--[[
Loads a Character Normally and puts it in its chosen spawn
]]
local function LoadCharacter(Character: Model, Player: Player)
	local HRP = Character:WaitForChild("HumanoidRootPart") :: BasePart
	--[[
	Gets your preference of SpawnsOnTouch
	]]
	if SpawnsOnTouch == true then
	LocalSpawns.SetSpawnOnTouch(Player, Character) 
	end
	--This is RN hardcoded to "TeamSpawns" but you can change it how you like and choose any other
	--Spawn Behavior
	local AvailableSpawns = LocalSpawns.GetTeamSpawns(Player.Team)
	local HRPSize = HRP.Size
	--Gets Permanent SPawns For certain Player
	local PermanentSpawn = LocalSpawns.GetPermanentSpawn(Player)
	
	--Changes Behaviour in function of your chosen Spawn Behavior
	if PermanentSpawn then
		local SpawnSize = PermanentSpawn.Size

		local Offset = (SpawnSize.Y / 2) + (HRPSize.Y / 2)

		HRP.CFrame = PermanentSpawn.CFrame * CFrame.new(0, Offset, 0)

		Character.Parent = WorkSpace
		Player.Character = Character
		
		--Gets if the chosen spawn has any ForceField Duration and Modifies it...
		--Actually you can use that time for anything else
		--Like him the a Sword for 1 second and then Destroy it
		--Heheheheheh im so evil
		if PermanentSpawn.Duration >= 1 then
			local FF = Instance.new("ForceField")
			FF.Visible = true
			FF.Parent = Character
			
			--If finds a ForceField, destroys it after the Spawn Duration
			task.delay(PermanentSpawn.Duration, function()
				local ForceField = Character:WaitForChild("ForceField")
				if ForceField then ForceField:Destroy() end
			end)
		end
	else
		--This gets a random Spawn if you dont have SpawnsOnTouch Activated
		if AvailableSpawns and #AvailableSpawns >= 1 then

			local RandomSpawn = math.random(1, #AvailableSpawns)

			local Spawn = AvailableSpawns[RandomSpawn]

			local SpawnSize = Spawn.Size
			
			--Offset to avoid Spawning people INSIDE the SpawnLocation, no matter their Y Size
			local Offset = (SpawnSize.Y / 2) + (HRPSize.Y / 2)

			HRP.CFrame = Spawn.CFrame * CFrame.new(0, Offset, 0)

			Character.Parent = WorkSpace
			Player.Character = Character
			--The Same duplicated ForceField Duration #2
			if Spawn.Duration >= 1 then
				local FF = Instance.new("ForceField")
				FF.Visible = true
				
				task.delay(1/60, function()
					FF.Parent = Character
				end)

				task.delay(Spawn.Duration, function()
					local ForceField = Character:WaitForChild("ForceField")

					if ForceField then ForceField:Destroy() end
				end)
			end
		else
			--This is Applied in case of no available spawns
			--help im hungry
			local SecurityOffset = HRPSize.Y / 2

			HRP.CFrame = DefaultFallBackPosIfNotSpawn * CFrame.new(0, SecurityOffset, 0)

			Character.Parent = WorkSpace
			Player.Character = Character
			print("There Are no Found SpawnPoints, please make sure you have Configured them Right")
		end
	end
end

--[[
Loads the character instantly with no Respawn Time (Used on PlayerAdded)
]]
function PlayerRespawnReplication.LoadStarterCharacter(Player: Player)
	local Character: Model? = nil
	
	--Gets the Character in a different thread to avoid More awiting... Theorically
	task.spawn(function()
		Character = PreLoadCharacter(Player)
	end)
	
	--Basically waits until character is ready
	while not Character do
		task.wait()
	end
	
	--Basically The Same Thin in LoadCharacter()
	--Yes im gonna compress code someday
	--Im to lazy to do it now
	--No, im not gonna explain thia}s again
	if SpawnsOnTouch == true then
	LocalSpawns.SetSpawnOnTouch(Player, Character)
	end
	local HRP = Character:WaitForChild("HumanoidRootPart") :: BasePart
	local AvailableSpawns = LocalSpawns.GetTeamSpawns(Player.Team)
	local HRPSize = HRP.Size
	local PermanentSpawn = LocalSpawns.GetPermanentSpawn(Player)

	if PermanentSpawn then
		local SpawnSize = PermanentSpawn.Size

		local Offset = (SpawnSize.Y / 2) + (HRPSize.Y / 2)

		HRP.CFrame = PermanentSpawn.CFrame * CFrame.new(0, Offset, 0)

		Character.Parent = WorkSpace
		Player.Character = Character
		
		--Same Duplicated ForceField Logic #3
		if PermanentSpawn.Duration >= 1 then
			local FF = Instance.new("ForceField")
			FF.Visible = true
			
			task.delay(1/60, function()
				FF.Parent = Character
			end)

			task.delay(PermanentSpawn.Duration, function()
				local ForceField = Character:WaitForChild("ForceField")
				if ForceField then ForceField:Destroy() end
			end)
		end
	else
		if AvailableSpawns and #AvailableSpawns >= 1 then

			local RandomSpawn = math.random(1, #AvailableSpawns)

			local Spawn = AvailableSpawns[RandomSpawn]

			local SpawnSize = Spawn.Size

			local Offset = (SpawnSize.Y / 2) + (HRPSize.Y / 2)

			HRP.CFrame = Spawn.CFrame * CFrame.new(0, Offset, 0)

			Character.Parent = WorkSpace
			Player.Character = Character
			
			--Same Duplicated ForceField Logic #4
			if Spawn.Duration >= 1 then
				local FF = Instance.new("ForceField")
				FF.Visible = true
				
				task.delay(1/60, function()
					FF.Parent = Character
				end)

				task.delay(Spawn.Duration, function()
					local ForceField = Character:WaitForChild("ForceField")

					if ForceField then ForceField:Destroy() end
				end)
			end
		else
			local SecurityOffset = HRPSize.Y / 2

			HRP.CFrame = DefaultFallBackPosIfNotSpawn * CFrame.new(0, SecurityOffset, 0)

			Character.Parent = WorkSpace
			Player.Character = Character
			print("There Are no Found SpawnPoints, please make sure you have Configured them Right")
		end
	end
end


--[[
Sets up Respawns and SpawnLocations on the server to finish initializing system
]]
function PlayerRespawnReplication.SetUpRespawn(Player: Player)
	Player.CharacterAdded:Connect(function(character)
		local Instances = character:GetDescendants()

		for _, Instance in ipairs(Instances) do
			if Instance:IsA("BasePart") then
				--Defines a Hardcoded Collision Group For Spawns
				Instance.CollisionGroup = CollisionGroup
			end
		end

		local Human = character:WaitForChild("Humanoid") :: Humanoid
		local function ListenForDeath(Humanoid: Humanoid)
			--Hears Death Anytime a Player Dies
			Humanoid.Died:Connect(function()
				local Character: Model? = nil
				--Preloads the Character in a different Thread to avoid more waiting
				task.spawn(function()
					Character = PreLoadCharacter(Player)
				end)
				task.delay(TimeToRespawn, function()
					while not Character do
						task.wait()
					end
					--Finishes Setup and Puts the Character on the WorkSpace
					LoadCharacter(Character, Player)
				end)
			end)
		end
		--Forgotten Function to hear Humanoids Death
		ListenForDeath(Human)
	end)
end

return PlayerRespawnReplication