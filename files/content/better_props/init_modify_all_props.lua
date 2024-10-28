-- Collection of many props tweaked en mass
--  * Emits 20x more particles
--  * Bleeds 10x more
--  * Anything with a material inventory gets launched when hit
--  * 25x more material dropped on entity death

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
nxml.error_handler = function() end
local prop_files = dofile_once("mods/noita.fairmod/files/content/better_props/prop_files.lua") --- @type table

------------------------------------------------------------------------

---@param component element
---@param name string
---@param multiplier number
local function elem_multiply_attr(component, name, multiplier)
	if component:get(name) then component:set(name, tonumber(component:get(name)) * multiplier) end
end

---@param element element?
local function fixup_prop_children(element)
	if element == nil then return end

	for comp in element:each_of("ParticleEmitterComponent") do
		comp:set("create_real_particles", 1)
		comp:set("emit_cosmetic_particles", 0)
		elem_multiply_attr(comp, "count_min", 3)
		elem_multiply_attr(comp, "count_max", 3)
	end

	for comp in element:each_of("DamageModelComponent") do
		comp:set("blood_multiplier", 3)
		-- better chance to see things fly around instead of exploding immediately
		-- try not to modify enemy hp
		if element:first_of("AnimalAIComponent") == nil then
			if tonumber(comp:get("hp") or "1") < 1 then comp:set("hp", 1) end
			elem_multiply_attr(comp, "hp", 2)
		end
	end

	for comp in element:each_of("MaterialInventoryComponent") do
		-- More sane defaults for components that don't have these set
		-- Use normal defaults if it has b2_force_on_leak
		if comp:get("b2_force_on_leak") ~= nil then
			comp:apply_defaults({
				MaterialInventoryComponent = {
					leak_pressure_min = 0.7,
					leak_pressure_max = 1.1,
				},
			})
		else
			comp:apply_defaults({
				MaterialInventoryComponent = {
					leak_pressure_min = 0.1,
					leak_pressure_max = 0.25,
					b2_force_on_leak = 0.2,
				},
			})
		end
		elem_multiply_attr(comp, "leak_pressure_min", 2)
		elem_multiply_attr(comp, "leak_pressure_max", 6)
		elem_multiply_attr(comp, "b2_force_on_leak", -5)
		comp:set("on_death_spill", true)
		comp:set("leak_on_damage_percent", 0.999)

		for mat_count in comp:each_of("count_per_material_type") do
			for mat in mat_count:each_of("Material") do
				elem_multiply_attr(mat, "count", 3)
			end
		end
	end

	for comp in element:each_of("ProjectileComponent") do
		for conf in comp:each_of("config_explosion") do
			if (conf:get("create_cell_probability") or "0") ~= "0" then conf:set("create_cell_probability", 100) end
		end
	end
end

------------------------------------------------------------------------

for _, prop_file in ipairs(prop_files) do
	for prop_xml in nxml.edit_file(prop_file) do
		fixup_prop_children(prop_xml)
		fixup_prop_children(prop_xml:first_of("Base"))
	end
end
