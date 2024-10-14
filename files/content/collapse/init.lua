local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

-- Add another falling chunks to the right of the original
for chunks in nxml.edit_file("data/entities/misc/loose_chunks_workshop.xml") do
	chunks:add_child(nxml.new_element("Entity",{}, {
		nxml.new_element("InheritTransformComponent",{},{
			nxml.new_element("Transform", {
				["position.x"] = "150"
			})
		}),
		nxml.new_element("LooseGroundComponent", {
			probability="0.25",
			max_distance="180",
			max_angle="2.1",
			chunk_probability="0.15",
			collapse_images="data/procedural_gfx/collapse_big/$[0-14].png",
			chunk_material="concrete_collapsed",
		})
	}))
end

-- Increase area damage time
for areadmg in nxml.edit_file("data/entities/misc/workshop_areadamage.xml") do
	local lifetime = areadmg:first_of("LifetimeComponent")
	if lifetime then
		lifetime:set("randomize_lifetime.min", 1000)
		lifetime:set("randomize_lifetime.max", 30000)
	end
end
