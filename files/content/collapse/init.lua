local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

-- Add another falling chunks to the right of the original
for chunks in nxml.edit_file("data/entities/misc/loose_chunks_workshop.xml") do
	for x=-4,1 do
		if x ~= 0 then
			chunks:add_child(nxml.new_element("Entity",{}, {
				nxml.new_element("InheritTransformComponent",{},{
					nxml.new_element("Transform", {
						["position.x"] = tostring(x * 180)
					})
				}),
				nxml.new_element("LooseGroundComponent", {
					probability="0.25",
					max_distance="200",
					max_angle="2.1",
					chunk_probability="0.2",
					collapse_images="data/procedural_gfx/collapse_big/$[0-14].png",
					chunk_material="concrete_collapsed",
				})
			}))
		end
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
	collapse_trigger:add_child(nxml.new_element("InheritTransformComponent",{},{
		nxml.new_element("Transform", {
			["position.x"] = "50"
		})
	}))

	local collision = collapse_trigger:first_of("CollisionTriggerComponent")
	if collision == nil then break end

	collapse_trigger:remove_child(collision)
	collision:set("width", 150)

	local collision2 = nxml.new_element("CollisionTriggerComponent", MergeTables(collision.attr))
	collision2:set("required_tag", "player_polymorphed")

	collapse_trigger:add_child(nxml.new_element("Entity",{}, {
		nxml.new_element("InheritTransformComponent",{},{
			nxml.new_element("Transform", {
				["position.x"] = "50"
			})
		}),
		collision,
		collision2,
		nxml.new_element("LuaComponent", {
			script_collision_trigger_hit="data/scripts/buildings/workshop_exit.lua",
			execute_every_n_frame="-1",
		})
	}))
end
