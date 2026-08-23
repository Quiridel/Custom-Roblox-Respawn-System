--!strict
--[[
This Is For The Overrides of the system, you can choose here your default animations
let the player choose, or create your own ones and Implement them to all spawned Players

By Estebanjesus4

V1.1.0
]]
export type HumanoidAnimations = {
	IdleAnimation1: number,
	IdleAnimation2: number,
	WalkAnimation: number,
	RunAnimation: number,
	JumpAnimation: number,
	FallAnimation: number,
	ClimbAnimation: number,
	SwimAnimation: number,
	SwimIdleAnimation: number,
	SitAnimation: number,
}

local Overrides = {}

local Animations: {[string]: HumanoidAnimations} = {}

--[[
Here Basically Occurs the Register of the Anims, you can create your own anaimation set or choose any of this ones
here a Example for creating your own ones:

Animations.AnyNameYouWant = {
	IdleAnimation1 = SomeAnimationID,
	IdleAnimation2 = 507766951,
	WalkAnimation = habskjitnchbuyaksc, This is not valid bro
	RunAnimation = 507767714,
	JumpAnimation = 507765000,
	FallAnimation = 507767968,
	ClimbAnimation = 507765644,
	SwimAnimation = ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠤⠐⠒⠒⠒⠒⠢⠤⠤⠤⠀⠄⠲⠀
⠀⠀⠀⠀⠰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠚⢲⠀
⠀⠀⠀⠀⠀⠁⠀⠿⠿⡿⠿⠿⢿⣶⡀⠀⠰⠋⠀⠀
⠀⠀⠀⠀⠀⢀⣿⣿⡇⢸⣿⣿⡇⣙⡃⠠⠈⠁⠀⠀
⠀⠀⠀⠀⠀⣄⡉⢉⣵⣮⣭⡍⠑⣿⣿⡆⠀⠤⠀⠀
⢀⣰⣶⡶⡶⠟⠻⠻⠟⠿⠛⢁⣴⣿⠏⠁⠀⡐⠚⠀
⠀⠀⠀⠀⠀⠈⢿⣇⠹⠉⠹⣾⣿⠏⠀⣀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⠄⠁⢾⣈⣙⣀⣿⡏⠀⠡⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠈⠀⠀⠀⢤⣤⣤⠄⠀⠀⠀⠰⠀⠀⠀⠀
⠀⣤⣤⠁⢀⠂⡀⠀⠀⠙⠁⠀⠀⠘⢂⠀⠁⡄⠀⠀
⠈⠙⠛⠈⠀⠀⢡⠀⠀⠀⠀⠀⢸⠀⠀⠰⢈⣿⣶⠀
⠀⠀⠀⠀⠀⠀⠀⠰⣠⡤⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠙⠧⠟⠏⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀, --Spamton Isnt a Valid ID btw
	SwimIdleAnimation = 507785072,
	SitAnimation = 2506281707",
}

]]

Animations.StandardR15 = {
	IdleAnimation1 = 507766666,
	IdleAnimation2 = 507766951,
	WalkAnimation = 507777826,
	RunAnimation = 507767714,
	JumpAnimation = 507765000,
	FallAnimation = 507767968,
	ClimbAnimation = 507765644,
	SwimAnimation = 507784897,
	SwimIdleAnimation = 507785072,
	SitAnimation = 2506281703,
}

--[[
If you are gonna make your own Animation Set you can leave Run, Swim and SwimIdle empty
they are completely unuseful
]]

Animations.StandardR6 = {
	IdleAnimation1 = 180435571,
	IdleAnimation2 = 180435792,
	WalkAnimation = 180426354,
	RunAnimation = 0, -- This is Unuseful for R6
	JumpAnimation = 125750702,
	FallAnimation = 180436148,
	ClimbAnimation = 180436334,
	SwimAnimation = 0, -- This is Unuseful for R6
	SwimIdleAnimation = 0, -- This is Unuseful for R6
	SitAnimation = 178130996,
}

--This Just Returns Animations
Overrides.Animations = Animations

--[[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣀⣸⣄⠀⠀⠠⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣦⡏⠈⢀⣴⣄⣁⣽⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢀⠀⠀⠀⠻⢿⣿⣿⣿⣿⣿⡧⣤⡴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠉⢷⣶⣦⣤⣤⣝⣯⣝⢫⣾⣷⡋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣤⣮⣿⡿⢿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⣴⠿⠋⠉⠀⠀⢼⣍⣭⣟⠋⠙⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣴⠶⣿⡇⠀⠀⠀⠀⠀⣰⣿⢿⣿⡓⠀⠘⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢻⣶⣿⠰⠆⠀⠀⠀⣴⣿⠃⢸⣿⠀⠀⠠⣼⢿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣼⣿⡇⠀⢸⡟⠀⠀⠀⠀⠈⠯⣾⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣀⣼⡇⠀⠀⠀⠀⠀⠀⠘⢿⣿⣶⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣦⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢿⣿⣦⣀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣛⠿⣿⣦⣀

This Guy is Kris did you know?
]]

return Overrides