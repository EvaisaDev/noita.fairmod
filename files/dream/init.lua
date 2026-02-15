function OnPlayerSpawned(player)
	do return end
	if GameHasFlagRun("fairmod_lovely_dream_player_spawn_flag") then return end
	GameAddFlagRun("fairmod_lovely_dream_player_spawn_flag")

	local x,y = EntityGetTransform(player)
	EntityLoad("mods/noita.fairmod/files/dream/empty_kiosk.xml", x + 10, y + 11)
end

---@type nxml
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua")


--Hämis shall never be harmed, not even in the absence of the Fairmod.
for xml in nxml.edit_file("data/entities/animals/longleg.xml") do
	local remove_list = {}
	for child in xml:each_child() do
		remove_list[#remove_list+1] = child
	end
	for i = 1, #xml.children do
		xml:remove_child_at(i)
	end

	xml:add_child(nxml.new_element("LifetimeComponent", {
		lifetime = 1
	}))
end



local px,py = 0,0
function OnPlayerSpawned(player)
	EntitySetTransform(player, px, py)
end


local hm_y_levels = {
	1419,
	2955,
	5003,
	6539,
	8587,
	10635,
	13176,
}

function OnMagicNumbersAndWorldSeedInitialized()
	local a,b,c,d,e,f = GameGetDateAndTimeLocal()
	SetRandomSeed(a*d, e*-b)

	local rnd = Random(1, #hm_y_levels + 1) and 7
	rnd = 1
	local hm_desk_x = rnd == #hm_y_levels and 2392 or -680 --if its the last entry in the list, then its the final holy mountain and the X is offset too
	local hm_desk_y = hm_y_levels[rnd]
	table.remove(hm_y_levels, rnd)

	rnd = Random(1, #hm_y_levels + 1)
	local hm_phone_x = rnd == #hm_y_levels and 2334 or -738
	local hm_phone_y = hm_y_levels[rnd] - 15

	px,py = hm_desk_x,hm_desk_y


	local load_entities = {
		{ --information_kiosk
			path = "mods/noita.fairmod/files/dream/kiosk/empty_kiosk.xml",
			x = 237,
			y = -74
		},
		{ --mask_box
			path = "mods/noita.fairmod/files/dream/mask_box/abandoned_mask_box.xml",
			x = 771,
			y = -88
		},
		{ --spawn 3 minecarts at the entrance from entrance_cart module
			path = "data/entities/props/physics/minecart.xml",
			x = 1000,
			y = 114
		},
		{ --loanprey
			path = "data/entities/props/physics/minecart.xml",
			x = 1088,
			y = 113
		},
		{
			path = "data/entities/props/physics/minecart.xml",
			x = 837,
			y = -88
		},
		{
			path = hm_desk_y and "mods/noita.fairmod/files/dream/empty_desk/empty_desk.xml",
			x = hm_desk_x,
			y = hm_desk_y
		},
		{
			path = hm_phone_y and "mods/noita.fairmod/files/dream/haunted_phone/haunted_phone.xml",
			x = hm_phone_x,
			y = hm_phone_y
		},
		{
			path = "",
			x = 3572,
			y = 13104
		},
		{
			path = "",
			x = 0,
			y = 0
		},
		{
			path = "",
			x = 0,
			y = 0
		},
	}
	for xml in nxml.edit_file("data/biome/_pixel_scenes.xml") do

		local buffered_pixel_scenes = xml:nth_of("mBufferedPixelScenes", 1)
		if buffered_pixel_scenes then
			local entities = {}
			for _,entity in ipairs(load_entities) do
				if entity.path then
					if entity.path == "" then break end
					entities[#entities+1] = nxml.new_element("PixelScene", {
						just_load_an_entity = entity.path,
						pos_x = entity.x,
						pos_y = entity.y,
					})
				end
			end
			buffered_pixel_scenes:add_children(entities)
		end
	end
end