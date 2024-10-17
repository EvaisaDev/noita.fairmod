-- Put together by ScipioWright
-- I copied Eba's fuckedupenemies file as a base, so this is me giving credit

local orbs_data = {
	orb_adjusted = {},
    enemy_base_health = {},
}

local function get_scaled_health(health, orb_count)
    -- thank you Heinermann
    return health + 2^orb_count + orb_count * health / 3
end

function orbs_data:give_health_boost(enemy, orb_count)
    local damage_model_comp = EntityGetFirstComponent(enemy, "DamageModelComponent")
    -- if for some reason there's no damage model component, just ignore it, it's probably something weird
    if not damage_model_comp then
        self.orb_adjusted[enemy] = 100
        return
    end

    local old_max_health = ComponentGetValue2(damage_model_comp, "max_hp")

    -- if this is the first time we've seen this enemy, store its max health
    if not self.orb_adjusted[enemy] or self.orb_adjusted[enemy] == 0 then
        self.enemy_base_health[enemy] = old_max_health
    end
    
    -- set its new max health and mark it so we don't just repeatedly set its health
    local new_max_health = get_scaled_health(self.enemy_base_health[enemy], orb_count)
    ComponentSetValue2(damage_model_comp, "max_hp", new_max_health)
    self.orb_adjusted[enemy] = orb_count

    -- scale up the enemy's current health, just in case it was damaged before you picked up an orb
    local current_health = ComponentGetValue2(damage_model_comp, "hp")
    ComponentSetValue2(damage_model_comp, "hp", current_health * new_max_health / old_max_health)
end

function orbs_data:OnWorldPreUpdate()
	local enemies = EntityGetWithTag("enemy")
    local props = EntityGetWithTag("prop")
    local animals = EntityGetWithTag("helpless_animal")
    for _, prop in ipairs(props) do
        table.insert(enemies, prop)
    end
    for _, animal in ipairs(animals) do
        table.insert(enemies, animal)
    end
    local orb_count = GameGetOrbCountThisRun()
	for _, enemy in ipairs(enemies) do
		if not orbs_data.orb_adjusted[enemy] or orbs_data.orb_adjusted[enemy] < orb_count then
			self:give_health_boost(enemy, orb_count)
		end
	end
end

return orbs_data
