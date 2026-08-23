A customizable replacement for Roblox's default character spawning and respawn system.

Custom Roblox Respawn System is a Luau module designed to replace Roblox's default character spawning behavior with a customizable system for controlling character creation, respawning, spawn selection, animations, collision groups and more.

The system disables Roblox's automatic character loading and handles character creation and spawning manually.

--Features

-Custom character spawning
  Manually creates player characters.
  Supports R6 and R15 rigs.
  Supports Roblox avatar descriptions.

-Custom respawning
  Custom respawn timing.
  Characters are preloaded before the respawn delay finishes when possible.
  Uses StarterPlayer settings where applicable.

-SpawnLocation support
  Detects SpawnLocations automatically.
  Supports neutral spawns.
  Supports team-based spawns.
  Detects SpawnLocations added or removed during runtime.
  Supports spawn-on-touch.

-Animation overrides
  Allows custom animation sets.
  Supports player-selected animations.
  Separate R6 and R15 animation configurations.

-Collision groups
  Includes configurable player collision groups.
  Supports custom collision behavior between players and other objects.
  SpawnLocations receive their own collision group.

-Dynamic configuration
  Several StarterPlayer properties are monitored and applied to newly created characters.

-Client camera handling
  Includes a client-side camera setup module for custom character spawning.

--Installation
1. Insert the module

Place the RespawnModule folder inside:

ReplicatedStorage
└── RespawnModule

The module and its child modules should remain together because the main module requires its internal systems.

2. Initialize the system

Require the module from a server script:

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RespawnModule = require(
    ReplicatedStorage:WaitForChild("RespawnModule")
)

RespawnModule.Initialize()

That's it.

The system automatically detects whether it is running on the server or client and initializes the appropriate components.

--How it works

When initialized on the server, the system:

Disables Roblox's automatic character loading.

Registers the configured collision groups.

Scans the Workspace for SpawnLocations.

Starts tracking SpawnLocation changes.

Configures respawning for players.

Creates their characters manually.

On the client, the camera system is initialized instead.

--Spawn System

SpawnSetUp
├── GetAllSpawns()
├── GetTeamSpawns()
├── GetUniversalSpawns()
├── GetAllAvailableSpawnsForPlayer()
├── SetSpawnOnTouch()
└── GetPermanentSpawn()

--Animation Overrides

Animations.MyAnimationSet = {
  IdleAnimation1 = 123456789,
  IdleAnimation2 = 123456789,
  WalkAnimation = 123456789,
  RunAnimation = 123456789,
  JumpAnimation = 123456789,
  FallAnimation = 123456789,
  ClimbAnimation = 123456789,
  SwimAnimation = 123456789,
  SwimIdleAnimation = 123456789,
  SitAnimation = 123456789,
}

You can create your own animation sets inside Overrides.luau and select them when creating characters.

--Roadmap

Aquí además podemos aprovechar tu filosofía de versiones:

## Roadmap

### v1.1.0
- [x] Custom respawning
- [x] Custom character creation
- [x] SpawnLocation tracking
- [x] Animation overrides
- [x] Collision groups
- [x] Error handling

Im going to start working on a patch for this

### v1.2.0
- [ ] Improve connection cleanup
- [ ] Improve PlayerRemoving handling
- [ ] Refactor duplicated character loading logic
- [ ] Improve collision group configuration
- [ ] Improve error recovery
- [ ] Further optimize character preloading
