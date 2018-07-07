if solo_map_logic == nil then
    solo_map_logic = class({})
end

function solo_map_logic:InitGameMode()
   --print( "InitGameMode" )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )

    GameRules:SetUseUniversalShopMode( true )
    GameRules:SetHeroSelectionTime( 0.0 )
    GameRules:SetStrategyTime( 0.0 )
    GameRules:SetShowcaseTime( 0.0 )
    GameRules:SetPreGameTime( 5.0 )

    GameRules:SetGoldTickTime( 60.0 )
    GameRules:SetGoldPerTick( 0 )
    GameRules:SetStartingGold( 0 )    

    GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
    GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )
    GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
    GameRules:GetGameModeEntity():SetFixedRespawnTime(30)

    --GameRules:GetGameModeEntity():SetCustomGameForceHero('npc_dota_hero_axe');
    --GameRules:GetGameModeEntity():SetCustomGameForceHero('npc_dota_hero_rubick');
    --GameRules:GetGameModeEntity():SetCustomGameForceHero('npc_dota_hero_dragon_knight');
    GameRules:GetGameModeEntity():SetCustomGameForceHero('npc_dota_hero_rattletrap');
    
    --GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(solo_map_logic, "DamageFilter"), self)

    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(solo_map_logic, 'GameRulesStateChange'), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(solo_map_logic, 'OnNPCSpawn'), self) 
    --ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(solo_map_logic, 'OnPlayerGainedLevel'), self)   
    ListenToGameEvent("dota_player_killed", Dynamic_Wrap(solo_map_logic, "OnSomeHeroKilled"), self)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(solo_map_logic, "OnEntityKilled"), self)
    --ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(solo_map_logic, 'OnItemPickedUp'), self)
    --ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(solo_map_logic, 'OnAbilityLearned'), self)
    ListenToGameEvent( "player_chat", Dynamic_Wrap( solo_map_logic, "OnChat" ), self )

   --AddFOWViewer(DOTA_TEAM_GOODGUYS, SPAWNER_OW_POINT, 2000, 60, false)
    --self:TestBosses()
    self:SpanwMoobs()
end

function solo_map_logic:GameRulesStateChange(data)
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    end
end


function solo_map_logic:OnNPCSpawn(data)
    --print("OnNPCSpawn")
    local unit = EntIndexToHScript(data.entindex)

    if unit:IsRealHero() then
        if not unit.next_spawn then
            unit.next_spawn = true; 
            unit:SetAbilityPoints(0)
            unit:SetGold(500, true)
     
            if unit:HasAnyAvailableInventorySpace() then
                unit:AddItemByName("item_blink")
                unit:AddItemByName("item_scarlet_stone_of_fire")
            end

        end
    end

end


function solo_map_logic:OnSomeHeroKilled(data)

end

function solo_map_logic:OnEntityKilled(data)
    
    local killedEntity = EntIndexToHScript(data.entindex_killed)

    if killedEntity:IsCreature()  then
        if killedEntity.respawn then
            self:RespawnUnit(killedEntity:GetUnitName(),killedEntity.vSpawnLoc,killedEntity.modifierName, LAND_MINE_RESPAWN_TIME)
        end
    end

    if killedEntity:IsRealHero()  then

    end    
end

function solo_map_logic:SpanwMoobs()

    local point = nil
    local unit = nil
--[[
    point = Entities:FindByName( nil, "spawner_3"):GetAbsOrigin()
    unit = CreateUnitByName("npc_creature_land_mine", point, true, nil, nil, DOTA_TEAM_BADGUYS )
    unit.vSpawnLoc = unit:GetAbsOrigin()
    unit.respawn = true
    unit.modifierName = "modifier_land_mine_invisible"
    unit:SetForwardVector(Vector(0,-1,0))
    unit:AddNewModifier(unit, nil, "modifier_land_mine_invisible", {})

    point = Entities:FindByName( nil, "spawner_2"):GetAbsOrigin()
    unit = CreateUnitByName("npc_creature_ore", point, true, nil, nil, DOTA_TEAM_BADGUYS )
    unit.vSpawnLoc = unit:GetAbsOrigin()
    unit.respawn = true
    unit.modifierName = "modifier_red_ore"
    unit:AddNewModifier(unit, nil, "modifier_red_ore", {})
]]

end


function solo_map_logic:OnItemPickedUp(data)
    --print("spawn")
end

function solo_map_logic:FocusCameraOnPlayer(player)
    PlayerResource:SetCameraTarget(player:GetPlayerOwnerID(),player)
    Timers:CreateTimer(1, function()
        PlayerResource:SetCameraTarget(player:GetPlayerOwnerID(), nil)
        return nil
    end
    )
end


--playerid,text,teamonly,userid,splitscreenplayer
function solo_map_logic:OnChat( data )

    local player = PlayerResource:GetPlayer(data.playerid) 
    local text = data.text
    if text == "-stopsound" then
        --print("StopSound")
        --EmitGlobalSound("Item.DropWorld")
        --StopSoundEvent("Invasion_of_evil.Nocturnus",player)
        --player:StopSound("Invasion_of_evil.Nocturnus")
        --StopSoundEvent("Invasion_of_evil.ShadowHouse",MUSIC_SOURCE)
        --StopSoundEvent("Invasion_of_evil.EpicFight1",MUSIC_SOURCE)
    end
end


function solo_map_logic:RespawnUnit(unitName,SpawnLoc,modifierName,time)

    local team = DOTA_TEAM_BADGUYS
    local unit = nil

    Timers:CreateTimer(time, function()
        unit = CreateUnitByName(unitName, SpawnLoc, true, nil, nil, team )
        unit.vSpawnLoc = SpawnLoc
        unit.respawn = true
        if modifierName then
            unit.modifierName = modifierName
            unit:AddNewModifier(unit, nil, modifierName, {})
        end
        return nil
    end
    )
end