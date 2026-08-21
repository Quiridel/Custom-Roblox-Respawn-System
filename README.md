# Custom-Roblox-Respawn-System
Tired of Roblox SpawnerService being unuseful and kinda annoying? me too, thats why i made my own system to deactivate the spawnerservice and with custom functions to control the player spawns how you want, is fully modular and customizable (you should read SpawnSetUp functions)

System updates values Dinamically and in real time, also changing roblox default spawn properties can override the configs


This is called the same way in the Server and the Client

```lua
--!strict
local ReplicatedStorage =  game:GetService("ReplicatedStorage")
local RespawnSystemModule = require(ReplicatedStorage:FindFirstChild("RespawnModule"))

RespawnSystemModule.Initialize()
```

Just make Sure to have the MainModule IN REPLICATEDSTORAGE, otherwise it wont work

To Choose any other Spawn Behaviors you can check the Functions in SpawnSetup or directly you can modify the system to your desires.

```SpawnSetUp.GetAllSpawns()``` Gets all the Available Spawns without ANY type of Filter and returns them

```SpawnSetUp.GetTeamSpawns(Team: Team)``` Get All the spawns connected to a certain team

```SpawnSetUp.GetUniversalSpawns()``` Gets all the Spawns making Sure they are Enabled and have Neutral == true

```SpawnSetUp.GetAllAvailableSpawnsForPlayer(Player: Player)```  Gets all Spawns for a certain player depending on his team
