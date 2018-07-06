if work_map_logic == nil then
    work_map_logic = class({})
end

function work_map_logic:InitGameMode()
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

    --GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(work_map_logic, "DamageFilter"), self)

    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(work_map_logic, 'GameRulesStateChange'), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(work_map_logic, 'OnNPCSpawn'), self) 
    --ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(work_map_logic, 'OnPlayerGainedLevel'), self)   
    ListenToGameEvent("dota_player_killed", Dynamic_Wrap(work_map_logic, "OnSomeHeroKilled"), self)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(work_map_logic, "OnEntityKilled"), self)
    --ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(work_map_logic, 'OnItemPickedUp'), self)
    --ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(work_map_logic, 'OnAbilityLearned'), self)
    ListenToGameEvent( "player_chat", Dynamic_Wrap( work_map_logic, "OnChat" ), self )

   --AddFOWViewer(DOTA_TEAM_GOODGUYS, SPAWNER_OW_POINT, 2000, 60, false)
    --self:TestBosses()
    self:SpanwMoobs()
end

function work_map_logic:GameRulesStateChange(data)
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    end
end


function work_map_logic:OnNPCSpawn(data)
    --print("OnNPCSpawn")
    local unit = EntIndexToHScript(data.entindex)

    if unit:IsRealHero() then
        if not unit.next_spawn then
            unit.next_spawn = true; 
            unit:SetAbilityPoints(0)
            unit:SetGold(500, true)
     
            if unit:HasAnyAvailableInventorySpace() then
                unit:AddItemByName("item_blink")
                --unit:AddItemByName("item_heart")
            end

        end
    end

end


function work_map_logic:OnSomeHeroKilled(data)

end

function work_map_logic:OnEntityKilled(data)
    
    local killedEntity = EntIndexToHScript(data.entindex_killed)

    if killedEntity:IsCreature()  then
    end

    if killedEntity:IsRealHero()  then

    end    
end

function work_map_logic:SpanwMoobs()

    local point = nil
    local unit = nil

    point = Entities:FindByName( nil, "spawner_1"):GetAbsOrigin()
    unit = CreateUnitByName("npc_dota_neutral_kobold", point, true, nil, nil, DOTA_TEAM_BADGUYS )
    unit:SetForwardVector(Vector(0,-1,0))
end



function work_map_logic:CreateDrop(itemName, pos)
   local newItem = CreateItem(itemName, nil, nil)
   newItem:SetPurchaseTime(0)
   local drop = CreateItemOnPositionSync(pos, newItem)
   newItem:LaunchLoot(false, 300, 0.75, pos + RandomVector(RandomFloat(50, 50)))

    Timers:CreateTimer(TIME_BEFORE_REMOVE_DROP, function()
        if newItem and IsValidEntity(newItem) then
            if not newItem:GetOwnerEntity() then 

                if drop and IsValidEntity(drop) then 
                    UTIL_Remove(drop) 
                end

                UTIL_Remove(newItem)
            end
        end
      return nil
    end
    )
end


function work_map_logic:OnItemPickedUp(data)
    --print("spawn")
end

function work_map_logic:FocusCameraOnPlayer(player)
    PlayerResource:SetCameraTarget(player:GetPlayerOwnerID(),player)
    Timers:CreateTimer(1, function()
        PlayerResource:SetCameraTarget(player:GetPlayerOwnerID(), nil)
        return nil
    end
    )
end


--playerid,text,teamonly,userid,splitscreenplayer
function work_map_logic:OnChat( data )

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

