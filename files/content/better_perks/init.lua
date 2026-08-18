---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")


ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/better_perks/append.lua")
ModLuaFileAppend("data/scripts/perks/attract_items.lua", "mods/noita.fairmod/files/content/better_perks/extend_attract_items.lua")
ModLuaFileAppend("data/entities/animals/boss_centipede/rewards/spawn_rewards.lua", "mods/noita.fairmod/files/content/better_perks/extend_spawn_rewards.lua")


for xml in nxml.edit_file("data/entities/misc/greed_curse/greed.xml") do
    local remove = {}
    for elem in xml:each_of("LuaComponent") do
        remove[#remove+1] = elem
    end
    for _, elem in ipairs(remove) do
        xml:remove_child(elem)
    end
end

-- Stuff that Attract Gold should also attract because they are gold
local goldlike_stuff = {
	"data/entities/items/pickup/physics_gold_orb.xml",
	"data/entities/items/pickup/physics_gold_orb_greed.xml",
	"data/entities/projectiles/bomb_holy.xml",
	"data/entities/projectiles/bomb_holy_giga.xml",
}
for _, filename in ipairs(goldlike_stuff) do
	for xml in nxml.edit_file(filename) do
		local tags = xml:get("tags") or ""
		if tags == "" then tags = tags .. "," end
		xml:set("tags", tags .. "fair_gold")
	end
end

-- Make helpers/minions much more better
-- So helpful they can carry stuff for you
-- definitely will be very helpful and not hinder you in any way :)

-- true = needs controls
local minion_files = {
	["data/entities/misc/perks/angry_ghost.xml"] = true,
	["data/entities/misc/perks/hungry_ghost.xml"] = true,
	["data/entities/misc/homunculus.xml"] = false,
	["data/entities/misc/perks/lukki_minion.xml"] = true,
	["data/entities/base_helpless_animal.xml"] = false,
}

for file, needs_controls in pairs(minion_files) do
	for xml in nxml.edit_file(file) do
		if needs_controls then
			xml:add_child(
				nxml.new_element("ControlsComponent", { enabled = 0 })
			)
		end

		xml:add_child(
			nxml.new_element("ItemPickUpperComponent", {
				is_in_npc = 1,
				pick_up_any_item_buggy = 1,
				is_immune_to_kicks = 0,
				drop_items_on_death = 1,
			})
		)
	end
end

-- Stronger Hearts
local heart_files = {
	"data/entities/items/pickup/heart.xml",
	"data/entities/items/pickup/heart_better.xml",
}
for _, f in ipairs(heart_files) do
	for xml in nxml.edit_file(f) do
		xml:create_child("LuaComponent", {
			execute_on_added = 1,
			remove_after_executed = 1,
			script_source_file = "mods/noita.fairmod/files/content/better_perks/stronger_hearts/buff_hearts_check.lua",
		})
	end
end
