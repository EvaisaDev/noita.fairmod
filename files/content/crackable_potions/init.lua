local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file("data/entities/items/pickup/potion.xml") do
	xml:add_children({
		nxml.new_element("LuaComponent", {
			_enabled = 0,
			_tags = "enabled_in_inventory,enabled_in_hand",
			script_source_file = "mods/noita.fairmod/files/content/crackable_potions/potion_crack_script.lua"
		}),
		nxml.new_element("VariableStorageComponent", {
			_tags = "enabled_in_inventory,enabled_in_hand",
			name = "fairmod_last_material_amount",
			value_int = 0,
		}),
		nxml.new_element("VariableStorageComponent", {
			_tags = "enabled_in_inventory,enabled_in_hand",
			name = "fairmod_potion_cracked_stage",
			value_int = 0,
		}),
		nxml.new_element("VariableStorageComponent", {
			_tags = "enabled_in_inventory,enabled_in_hand",
			name = "fairmod_last_last_frame_drank",
			value_int = 0,
		}),
	})
end


-- Procedurally generate item gfx with cracks

local function copy_img(dst, src)
	for y = 0, 15 do
		for x = 0, 15 do
			local px = ModImageGetPixel(src, x, y)
			if bit.rshift(px, 24) == 255 then	-- is opaque pixel
				ModImageSetPixel(dst, x, y, px)
			end
		end
	end
end

local potion_id = ModImageMakeEditable("data/ui_gfx/items/potion.png", 16, 16)
local cracks = {}
for i = 1,7 do
	local filename = "mods/noita.fairmod/files/content/crackable_potions/cracks/crack" .. tostring(i) .. ".png"
	local imgid = ModImageMakeEditable(filename, 16, 16)
	table.insert(cracks, imgid)
end

-- Cracks stage 1
for i=1,7 do
	local filename = table.concat{"data/ui_gfx/items/potion.png.fairmod_", tostring(i), ".png"}
	local imgid = ModImageMakeEditable(filename, 16, 16)
	copy_img(imgid, potion_id)
	copy_img(imgid, cracks[i])
end

-- Cracks stage 2
for i=1,7 do
	for j=i+1,7 do
		local filename = table.concat{"data/ui_gfx/items/potion.png.fairmod_", tostring(i), "_", tostring(j), ".png"}
		local imgid = ModImageMakeEditable(filename, 16, 16)
		copy_img(imgid, potion_id)
		copy_img(imgid, cracks[i])
		copy_img(imgid, cracks[j])
	end
end

-- Cracks stage 3
for i=1,7 do
	for j=i+1,7 do
		for k=j+1,7 do
			local filename = table.concat{"data/ui_gfx/items/potion.png.fairmod_", tostring(i), "_", tostring(j), "_", tostring(k), ".png"}
			local imgid = ModImageMakeEditable(filename, 16, 16)
			copy_img(imgid, potion_id)
			copy_img(imgid, cracks[i])
			copy_img(imgid, cracks[j])
			copy_img(imgid, cracks[k])
		end
	end
end

