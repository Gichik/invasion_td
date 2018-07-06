
if modifier_land_mine_invisible == nil then
    modifier_land_mine_invisible = class({})
end

function modifier_land_mine_invisible:IsHidden()
	return true
end

function modifier_land_mine_invisible:GetTexture()
    return "shadow_shaman_voodoo"
end

function modifier_land_mine_invisible:RemoveOnDeath()
	return true
end

function modifier_land_mine_invisible:DeclareFunctions()
    return nil
end

function modifier_land_mine_invisible:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
        self.castRange = self.caster:GetCurrentVisionRange()
        self.caster:AddNewModifier(self.caster, nil, "modifier_invisible", {})
		self:StartIntervalThink(0.5)
	end
end

function modifier_land_mine_invisible:OnIntervalThink()
	if self.caster then
		local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.caster, self.castRange,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )

        if #units > 0 then
            self:Destroy()
		end	
	end
end

function modifier_land_mine_invisible:OnDestroy()
    if IsServer() then
        if self.caster then
            self.caster:RemoveModifierByName("modifier_invisible")
            self.caster:AddNewModifier(self.caster, nil, "modifier_land_mine_visible", {})
        end
    end
end
-------------------------------------------------------------------------

modifier_land_mine_visible = class({})

function modifier_land_mine_visible:IsHidden()
    return true
end

function modifier_land_mine_visible:RemoveOnDeath()
    return true
end

function modifier_land_mine_visible:GetTexture()
    return "shadow_shaman_voodoo"
end

function modifier_land_mine_visible:DeclareFunctions()
    return nil
end

function modifier_land_mine_visible:OnCreated()
    if IsServer() then
        self.caster = self:GetCaster()
        self.explosionDamage = 100;
        self.tickCount = 0;
        self.maxTickCount = 3;
        self.castRange = self.caster:GetCurrentVisionRange()
        EmitSoundOn("Hero_Techies.LandMine.Priming", self.caster)
        self:StartIntervalThink(0.5)
    end
end

function modifier_land_mine_visible:OnIntervalThink()
    if self.caster then
        local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.caster, self.castRange,
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )

        if #units > 0 then
            self.tickCount = self.tickCount + 1;
            if self.tickCount >= self.maxTickCount then
                self:Destroy()
            end
        else
            self:Destroy()
        end
    end
end

function modifier_land_mine_visible:OnDestroy()
    if IsServer() then
        if self.caster then
            if self.tickCount >= self.maxTickCount then
                self.caster:ForceKill(false)

                EmitSoundOn("Hero_Techies.LandMine.Detonate",  self.caster)
                ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self.caster)

                local units = FindUnitsInRadius(  self.caster:GetTeamNumber(),  self.caster:GetAbsOrigin(),  self.caster, self.castRange,
                DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )

                if units then
                    for i = 1, #units do
                        ApplyDamage({
                            victim = units[ i ],
                            attacker = self.caster,
                            damage = self.explosionDamage,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self
                        })
                    end
                end
            else
                self.caster:AddNewModifier(self.caster, nil, "modifier_land_mine_invisible", {})
            end
        end
    end
end