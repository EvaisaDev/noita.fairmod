function has_modifiers()
	return true
end
function biome_modifier_applies_to_biome()
	return true
end

local added_biomes = {
	"clouds",
	"the_sky",
	"dragoncave",
	"wandcave",
	"wizardcave",
	"boss_arena",
	"boss_victoryroom",
	"desert",
	"hills",
	"gold",
	"lake",
	"lava",
	"null_room",
	"pyramid",
	"rainforest_dark",
	"shop_room",
	"winter",
	"fungiforest",
	"water",
	"teleroom",
	"song_room",
	"scale",
	"lavalake",
	"excavationsite_cube_chamber",
	"friend_1",
	"friend_2",
	"friend_3",
	"friend_4",
	"friend_5",
	"friend_6",
	"bridge",
	"temple_altar",
	"essenceroom",
	"mountain_tree",
	"mountain_left_stub",
	"mountain_left_entrance",
	"orbrooms/orbroom_00",
	"orbrooms/orbroom_01",
	"orbrooms/orbroom_02",
	"orbrooms/orbroom_03",
	"orbrooms/orbroom_04",
	"orbrooms/orbroom_05",
	"orbrooms/orbroom_06",
	"orbrooms/orbroom_07",
	"orbrooms/orbroom_08",
	"orbrooms/orbroom_09",
	"orbrooms/orbroom_10",
	"orbrooms/orbroom_11",
	"roadblock",
	"mountain_tree",
	"liquidcave",
	"winter_caves",
	"vault_frozen",
	"lake_deep",
	"lake_statue",
	"mountain_lake",
	"sandcave",
	"meat",
	"robobase",
	"funroom",
}

for _, v in ipairs(added_biomes) do
	table.insert(biomes, { v })
end

for _, v in ipairs(biome_modifiers) do
	v.does_not_apply_to_biome = nil
	v.apply_only_to_biome = nil
end
