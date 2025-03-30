local entity_id = GetUpdatedEntityID()
local player = EntityGetRootEntity(entity_id)

if(entity_id == player)then
	EntityKill(entity_id)
	return
end

if(not GameHasFlagRun("fairmod_hampill_trial_ended"))then
	GameAddFlagRun("fairmod_hampill_trial_ended")
	ModSettingSet("noita.fairmod.popups", (ModSettingGet("noita.fairmod.popups") or "") .. "hampilled,")
end
local dmc = EntityGetFirstComponent(player, "DamageModelComponent") --[[@cast dmc number]]

local hp = 100 / 25
if dmc then
	ComponentSetValue2(dmc, "wait_for_kill_flag_on_death", false)
	ComponentSetValue2(dmc, "invincibility_frames", 0)
	ComponentSetValue2(dmc, "hp", 1)
	ComponentSetValue2(dmc, "max_hp", 1)
	ComponentSetValue2(dmc, "max_hp_cap", 0)
	hp = ComponentGetValue2(dmc, "hp")
end

local lua_comps = EntityGetComponentIncludingDisabled(player, "LuaComponent") or {}
for i, comp in ipairs(lua_comps) do
	EntityRemoveComponent(player, comp)
end

local children = EntityGetAllChildren(player) or {}
for i, child in ipairs(children) do

	EntityKill(child)

end

EntityInflictDamage(player, hp * 100, "DAMAGE_CURSE", "Hämis pills are not meant for noita consumption", "BLOOD_EXPLOSION", 0, 0, entity_id)

local px, py = EntityGetTransform(player)

SetRandomSeed(px, py)

local count = Random(3, 5)
-- spawn guts
for i = 1, count do
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/guts/guts" .. Random(1, 5) .. ".xml", px, py)
end



if(EntityGetIsAlive(player))then

	-- recursive bullshit because the player might have invincibility frames still for some reason help
	local free_trial = EntityLoad("mods/noita.fairmod/files/content/mailbox/hampill/free_trial.xml", x, y)

	local lifetime_comp = EntityGetFirstComponentIncludingDisabled(free_trial, "LifetimeComponent")
	if(lifetime_comp)then
		ComponentSetValue2(lifetime_comp, "lifetime", 1)
		ComponentSetValue2(lifetime_comp, "kill_frame", GameGetFrameNum() + 1)
	end

	EntityAddChild(player, free_trial)
end
