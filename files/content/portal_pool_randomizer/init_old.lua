local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")

local template = "data/biome_impl/temple/altar_top_water.png"

local pool_randomizer = {}

local ARGBToABGR = function(argb)
	local a = bit.rshift(bit.band(argb, 0xFF000000), 24)
	local r = bit.rshift(bit.band(argb, 0x00FF0000), 16)
	local g = bit.rshift(bit.band(argb, 0x0000FF00), 8)
	local b = bit.band(argb, 0x000000FF)

	return bit.bor(bit.lshift(b, 24), bit.lshift(g, 16), bit.lshift(r, 8), a)
end

local mats = {
	liquid = {},
	sand = {},
	gas = {},
	static = {}
}

function parse_tags(tags)
	local output = {}
	if tags == nil then
		return output
	end
	local a = string.gmatch(tags, "([^,]+)")
	for i in a do
		i = i:gsub("%[", "")
		i = i:gsub("%]", "")
		output[i] = true
	end
	return output
end


function findMaterial(xml, name)
	for k, v in pairs(xml.children)do
		if(v.attr.name == name)then
			return v
		end
	end
	return nil
end

function findAttribute(xml, element, property)
	if(element.attr[property])then
		return element.attr[property]
	else
		if(element.attr["_parent"])then
			if(findMaterial(xml, element.attr["_parent"]) ~= nil)then
				return findAttribute(xml, findMaterial(xml, element.attr["_parent"]), property)
			end
		end
	end
	return ""
end

function populate_mats()
	local materials = ModMaterialFilesGet()
	local final_xml = {}
	local all_children = {}
	for k, v in pairs(materials)do
		local content = ModTextFileGetContent(v)
		local xml = nxml.parse(content)

		for k, v in pairs(xml.children)do
			table.insert(all_children, v)
		end

		if(v == "data/materials.xml")then
			final_xml = xml
		end
	end
	
	final_xml.children = all_children
	local xml = final_xml
	if(xml ~= {})then
		for element in xml:each_child() do
			
			if(element.name == "CellData" or element.name == "CellDataChild")then
				local color = "44000000"

				if(element.children ~= nil)then
					for _, child in pairs(element.children)do
						if(child.name == "Graphics")then
							if(child.attr.color ~= nil)then
								color = child.attr.color
							end
						end
					end
				end

				if(string.sub(element.attr.name, -3) ~= "_b2" )then
					if(findAttribute(xml, element, "cell_type") == "liquid" and not (findAttribute(xml, element, "liquid_sand") == "1") and not (findAttribute(xml, element, "liquid_static") == "1"))then
		
						if(not string.find(element.name, "molten") and not string.find(element.name, "fading"))then
							table.insert(mats.liquid, {
								name = element.attr.name,
								ui_name = element.attr.ui_name,
								color = color or "44000000",
								wang_color = element.attr.wang_color,
								source = nxml.tostring(element)
							})
						end
					end
				end
			end
			
		end
	end
end

pool_randomizer.generate = function()


	local template_id, template_w, template_h = ModImageMakeEditable( template, nil, nil )


	print("Template id: "..template_id.." w: "..template_w.." h: "..template_h)

	local replace_color = ModImageGetPixel( template_id, 214, 56 )
	populate_mats()

	for i, v in ipairs(mats.liquid) do

		local color = v.wang_color

		local abgr = ARGBToABGR(tonumber(color, 16))

		local image_id, w, h = ModImageMakeEditable( "mods/noita.fairmod/custom_hm_pools/hm_pool_"..v.name..".png", template_w, template_h )

		print("Generating pool image: ".."mods/noita.fairmod/custom_hm_pools/hm_pool_"..v.name..".png")
		print("Image id: "..image_id.." w: "..w.." h: "..h)
		
		local new_img, new_w, new_h = ModImageIdFromFilename("mods/noita.fairmod/custom_hm_pools/hm_pool_"..v.name..".png")

		print("New image id: "..new_img.." w: "..new_w.." h: "..new_h)

		for x = 0, w-1 do
			for y = 0, h-1 do
				local template_color = ModImageGetPixel( template_id, x, y )
				
				if(template_color == replace_color)then
					ModImageSetPixel( image_id, x, y, abgr )
				else
					ModImageSetPixel( image_id, x, y, template_color )
				end
			end
		end

		print("Generated pool image: ".."mods/noita.fairmod/custom_hm_pools/hm_pool_"..v.name..".png")


	end
end

ModLuaFileAppend( "data/scripts/biomes/temple_altar_top_shared.lua", "mods/noita.fairmod/files/content/portal_pool_randomizer/append_pool.lua" )

return pool_randomizer