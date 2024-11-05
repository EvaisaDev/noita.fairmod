local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")


local chunk_data = {
	{
		x = -400,
		y = -40,
		max_distance = 140,
		max_angle = 2,
		collapse_images = "data/procedural_gfx/collapse_lavabridge/$[0-4].png",
		chunk_count = 10,
		probability = 1,
		chunk_probability = 1,
	},
	{
		x = -170,
		y = -20,
		max_distance = 140,
		max_angle = 2,
		collapse_images = "data/procedural_gfx/collapse_lavabridge/$[0-4].png",
		chunk_count = 10,
		probability = 1,
		chunk_probability = 1,
	},
	{
		x = 0,
		y = -40,
		max_distance = 140,
		max_angle = 1.8,
		collapse_images = "data/procedural_gfx/collapse_lavabridge/$[0-4].png",
		chunk_count = 10,
		probability = 1,
		chunk_probability = 1,
	},
	{
		x = 170,
		y = -25,
		max_distance = 160,
		max_angle = 2.6,
		collapse_images = "data/procedural_gfx/collapse_lavabridge/small_$[0-4].png",
		chunk_count = 10,
		probability = 1,
		chunk_probability = 1,
	},
}

-- Add another falling chunks to the right of the original
for xml in nxml.edit_file("data/entities/misc/loose_chunks_workshop.xml") do
	local og_chunks = xml:first_of("LooseGroundComponent")
	if og_chunks ~= nil then
		xml:remove_child(og_chunks)
	end

	for _, chunk in ipairs(chunk_data) do
		xml:add_child(nxml.new_element("Entity", {}, {
			nxml.new_element("InheritTransformComponent", {}, {
				nxml.new_element("Transform", {
					["position.x"] = chunk.x,
					["position.y"] = chunk.y
				}),
			}),
			nxml.new_element("LooseGroundComponent", {
				probability = chunk.probability,
				max_distance = chunk.max_distance,
				max_angle = chunk.max_angle,
				chunk_probability = chunk.chunk_probability,
				collapse_images = chunk.collapse_images,
				chunk_material = "concrete_collapsed",
				chunk_count = chunk.chunk_count,
			}),
		}))
	end

	local lifetime = xml:first_of("LifetimeComponent")
	if lifetime ~= nil then
		lifetime:set("lifetime", 15)
		lifetime:set("randomize_lifetime.min", 0)
	end
end

-- Increase curse damage time and area
for areadmg in nxml.edit_file("data/entities/misc/workshop_areadamage.xml") do
	local lifetime = areadmg:first_of("LifetimeComponent")
	if lifetime ~= nil then
		lifetime:set("randomize_lifetime.min", 600)
		lifetime:set("randomize_lifetime.max", 30000)
	end

	local dmg = areadmg:first_of("AreaDamageComponent")
	if dmg ~= nil then
		dmg:set("aabb_min.x", -400)
		dmg:set("aabb_max.x", 85)
		dmg:set("aabb_min.y", -200)
		dmg:set("aabb_max.y", 100)
	end

	local particles = areadmg:first_of("ParticleEmitterComponent")
	if particles ~= nil then
		particles:set("x_pos_offset_min", -405)
		particles:set("x_pos_offset_max", 90)
		particles:set("y_pos_offset_min", -205)
		particles:set("y_pos_offset_max", 105)
	end
end

-- Increase collapse trigger size
for collapse_trigger in nxml.edit_file("data/entities/buildings/workshop_exit.xml") do
	local collision = collapse_trigger:first_of("CollisionTriggerComponent")
	if collision == nil then break end

	collapse_trigger:remove_child(collision)
	collision:set("width", 150)

	local collision2 = nxml.new_element("CollisionTriggerComponent", MergeTables(collision.attr))
	collision2:set("required_tag", "polymorphed_player")

	collapse_trigger:add_children({
		nxml.new_element("Entity", {}, {
			nxml.new_element("InheritTransformComponent", {}, {
				nxml.new_element("Transform", {
					["position.x"] = 50,
				}),
			}),
			collision,
			collision2,
			nxml.new_element("LuaComponent", {
				script_collision_trigger_hit = "mods/noita.fairmod/files/content/collapse/workshop_exit_child.lua",
				execute_every_n_frame = -1,
			}),
		}),
	})
end


ModLuaFileAppend("data/scripts/perks/perk_pickup.lua", "mods/noita.fairmod/files/content/collapse/perk_pickup_append.lua")
