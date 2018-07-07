
if modifier_red_ore == nil then
    modifier_red_ore = class({})
end

function modifier_red_ore:IsHidden()
	return true
end

function modifier_red_ore:GetTexture()
    return "invoker_forge_spirit"
end

function modifier_red_ore:RemoveOnDeath()
	return true
end

function modifier_red_ore:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_red_ore:OnDeath(data)
	if IsServer() then
		if data.unit == self:GetParent() then
			local parent = self:GetParent()
			parent:AddNoDraw()

			EmitSoundOn("Ability.SandKing_CausticFinale", parent)

			SupFunction:CreateDrop("item_scarlet_stone_of_fire", parent:GetAbsOrigin())		
		end
	end
end

function modifier_red_ore:OnCreated()
	if IsServer() then
		self:GetParent():SetRenderColor(255, 69, 0) 
	end
end