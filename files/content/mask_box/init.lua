dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")
local appends = { "_pixel_scenes", "_pixel_scenes_newgame_plus" }

for k = 1, #appends do
	local path = table.concat({ "data/biome/", appends[k], ".xml" })
	local content = ModTextFileGetContent(path)
	local xml = nxml.parse(content)

	local scenes = xml:first_of("mBufferedPixelScenes")
	if scenes ~= nil then
		scenes:add_child(nxml.parse([[
			<PixelScene pos_x="771" pos_y="-88" just_load_an_entity="mods/noita.fairmod/files/content/mask_box/mask_box.xml" />
		]]))
		scenes:add_child(nxml.parse(table.concat({
			[[
			<PixelScene pos_x=pos_x="]],
			(771 + WORLD_WIDTH_HARDCODED),
			[[" pos_y="-88" just_load_an_entity="mods/noita.fairmod/files/content/mask_box/mask_box.xml" />
		]],
		})))
		scenes:add_child(nxml.parse(table.concat({
			[[
			<PixelScene pos_x="]],
			(771 - WORLD_WIDTH_HARDCODED),
			[[" pos_y="-88" just_load_an_entity="mods/noita.fairmod/files/content/mask_box/mask_box.xml" />
		]],
		})))
	end
	ModTextFileSetContent(path, tostring(xml))
end

do
	local path = "data/entities/player_base.xml"
	local content = ModTextFileGetContent(path)
	local xml = nxml.parse(content)
	xml:add_child(nxml.parse([[
		<SpriteComponent 
			_tags="character,i_am_mask"
			_enabled="0"
			alpha="1" 
			image_file="data/enemies_gfx/player.xml" 
			next_rect_animation="" 
			offset_x="6" 
			offset_y="14" 
			rect_animation="walk" 
			z_index="0.5"
		></SpriteComponent>
		]]))
	ModTextFileSetContent(path, tostring(xml))
end
