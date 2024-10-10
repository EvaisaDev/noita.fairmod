local ent = EntityGetRootEntity(GetUpdatedEntityID())
if not EntityHasTag(ent, "player_unit") and not EntityHasTag(ent, "player_polymorphed") then
	EntityKill(ent)
end

local x, y = EntityGetTransform(ent)
SetRandomSeed(x, y)

local effects = {
	function()
		EntityKill(GameGetWorldStateEntity())
	end,
	function()
		local world_width = BiomeMapGetSize() * 512
		if Random(1,2) == 1 then
			world_width = -world_width
		end
		EntitySetTransform(ent, x + world_width, y)
	end,
	function()
		GameDropAllItems(ent)
	end,
	function()
		dofile("data/scripts/newgame_plus.lua")
		do_newgame_plus()
	end,
}
effects[Random(1, #effects)]()
