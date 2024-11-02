local M = {}

---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")
ModMaterialsFileAdd("mods/noita.fairmod/files/content/saw/materials.xml")

for content in nxml.edit_file("data/entities/projectiles/deck/disc_bullet_big.xml") do
	content:first_of("ProjectileComponent"):set("on_death_gfx_leave_sprite", false)
	content:add_child(nxml.new_element("LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/saw/giga_death.lua",
		execute_every_n_frame = -1,
		execute_on_removed = true,
	}))
end

---@type OnPlayerSpawned
function M.OnPlayerSpawned(p)
	EntitySetDamageFromMaterial(p, "fairmod_metal_sharp", 0.01)
end

return M
