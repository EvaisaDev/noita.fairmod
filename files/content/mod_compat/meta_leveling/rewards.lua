local trash_rewards = {}
for i = 1, 30 do
	trash_rewards[i] = {
		id = string.format("fairmod_trash_reward_%d", i),
		ui_name = "excuse me?",
		description = "this is a fairmod",
		ui_icon = "",
		probability = 1,
		max = 1,
		fn = function()
			GamePrint("Placeholder message :3")
		end,
	}
end

local function spawn_tmtrainer_spell(type)
	local player = EntityGetWithTag("player_unit")[1]
	if not player then return end
	local x, y = EntityGetTransform(player)
	for i = 1, 1000 do
		local action_id = type and GetRandomActionWithType(x, y, 10, type, i) or GetRandomAction(x, y, 10, i)
		if not action_id or action_id == "" then break end
		if action_id:find("TMTRAINER_", 0, true) then
			CreateItemActionEntity(action_id, x, y + 20)
			return
		end
	end
	return
end

local tmtrainer_rewards = {
	{
		id = "fairmod_spell_random_tmtrainer",
		ui_name = "Random TMT spell",
		description = "Gives you a random tmt spell",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_high.xml",
		probability = 0.7,
		fn = function()
			spawn_tmtrainer_spell()
		end,
	},
	{
		id = "fairmod_spell_random_tmtrainer_projectile",
		ui_name = "Random TMT projectile",
		description = "Gives you a random tmt projectile",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile_high.xml",
		probability = 0.7,
		fn = function()
			spawn_tmtrainer_spell(0)
		end,
	},
	{
		id = "fairmod_spell_random_tmtrainer_modifier",
		ui_name = "Random TMT modifier",
		description = "Gives you a random tmt modifier",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier_high.xml",
		probability = 0.7,
		fn = function()
			spawn_tmtrainer_spell(2)
		end,
	},
}

local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_rewards(trash_rewards, "fairmod")
rewards_deck:add_rewards(tmtrainer_rewards, "fairmod")
