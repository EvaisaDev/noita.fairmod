local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

-- Add another falling chunks to the right of the original
for xml in nxml.edit_file("data/entities/misc/loose_chunks_workshop.xml") do
	local og_chunks = xml:first_of("LooseGroundComponent")
	if og_chunks ~= nil then
		xml:remove_child(og_chunks)
	end

	for x = -3, 1 do
		xml:add_child(nxml.new_element("Entity", {}, {
			nxml.new_element("InheritTransformComponent", {}, {
				nxml.new_element("Transform", {
					["position.x"] = tostring(x * 150),
				}),
			}),
			nxml.new_element("LooseGroundComponent", {
				probability = 0.6,
				max_distance = 200,
				max_angle = 2.6,
				chunk_probability = 0.8,
				collapse_images = "data/procedural_gfx/collapse_huge/$[0-14].png",
				chunk_material = "concrete_collapsed",
				chunk_count = 20,
			}),
		}))
	end
end

-- Increase area damage time
for areadmg in nxml.edit_file("data/entities/misc/workshop_areadamage.xml") do
	local lifetime = areadmg:first_of("LifetimeComponent")
	if lifetime then
		lifetime:set("randomize_lifetime.min", 1000)
		lifetime:set("randomize_lifetime.max", 30000)
	end
end

-- Increase collapse trigger size
for collapse_trigger in nxml.edit_file("data/entities/buildings/workshop_exit.xml") do
	collapse_trigger:add_child(nxml.new_element("InheritTransformComponent", {}, {
		nxml.new_element("Transform", {
			["position.x"] = "50",
		}),
	}))

	local collision = collapse_trigger:first_of("CollisionTriggerComponent")
	if collision == nil then break end

	collapse_trigger:remove_child(collision)
	collision:set("width", 150)

	local collision2 = nxml.new_element("CollisionTriggerComponent", MergeTables(collision.attr))
	collision2:set("required_tag", "polymorphed_player")

	collapse_trigger:add_child(nxml.new_element("Entity", {}, {
		nxml.new_element("InheritTransformComponent", {}, {
			nxml.new_element("Transform", {
				["position.x"] = "50",
			}),
		}),
		collision,
		collision2,
		nxml.new_element("LuaComponent", {
			script_collision_trigger_hit = "data/scripts/buildings/workshop_exit.lua",
			execute_every_n_frame = "-1",
		}),
	}))
end
