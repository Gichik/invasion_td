-- Generated from template
require( 'work_map_logic' )
require( 'constant_links' )
require( 'timers' )

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()

	local MapName = GetMapName()
	print(MapName)

	if MapName == "work_map" then
		print("----------------------------------------Work map Start----------------------------------------")
		GameRules:GetGameModeEntity():SetCustomGameForceHero('npc_dota_hero_rattletrap');
		work_map_logic:InitGameMode()
	end

	if MapName == "solo_map" then
		print("----------------------------------------Solo map Start----------------------------------------")
		--main:InitGameMode()
	end

end