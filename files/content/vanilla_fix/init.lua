
local vanilla_fix = {}

local catastrophicMaterials = {
    creepy_liquid = true, 
    monster_powder_test = true, 
    totallyBogusMaterial = true, 
    t_omega_slicing_liquid = true, 
    aa_chaotic_pandorium = true, 
    aa_unstable_pandorium = true,
} -- Catastrophic Materials list


local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

function vanilla_fix.OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
	-- this code adds tags to preexisting materials, its good for compatibility--
	local xml = nxml.parse(ModTextFileGetContent("data/materials.xml"))

	local files = ModMaterialFilesGet()
	for _, file in ipairs(files) do --add modded materials
		if file ~= "data/materials.xml" then
			for _, comp in ipairs(nxml.parse(ModTextFileGetContent(file)).children) do
				xml.children[#xml.children+1] = comp
			end
		end
	end

	for elem in xml:each_child() do
		local attr = elem.attr

		if catastrophicMaterials[attr.name] then
			attr.tags = attr.tags .. ",[catastrophic]"	
			print("Fairmod: Added tag [catastrophic] to " .. attr.name)
		end
        
		if attr.convert_to_box2d_material or attr.solid_break_to_type or attr.cell_type == "solid" or string.find(attr.name, "[catastrophic]") then
			if attr.tags then
				attr.tags = attr.tags .. ",[NO_FUNGAL_SHIFT]"
			else
				attr.tags = "[NO_FUNGAL_SHIFT]"
			end
			--print("Fairmod: Added tag [NO_FUNGAL_SHIFT] to " .. attr.name)
		end
	end
end


return vanilla_fix