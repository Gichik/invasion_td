-- Generated from template
require( 'work_map_logic' )
require( 'constant_links' )
require( 'modifiers_links' )
require( 'timers' )

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]


	------------------------------------------------models-----------------------------------------------------
	PrecacheResource( "model", "models/heroes/techies/fx_techiesfx_mine.vmdl", context ) --land mine
	PrecacheResource( "model", "models/props_gameplay/crystal_ring01.vmdl", context ) --ore
	PrecacheResource( "model", "models/props_gameplay/rune_haste01.vmdl", context ) --red crystals


	------------------------------------------------particles-----------------------------------------------------
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context ) --land mine
	PrecacheResource( "particle", "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion_streak.vpcf", context ) --red ore

	------------------------------------------------sound-----------------------------------------------------
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context ) --land mine
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context ) --ore


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