local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local peaceful_biomes = { "data/biome/hills.xml", "data/biome/desert.xml", "data/biome/lake.xml" }

local rain_material_data = dofile_once("mods/noita.fairmod/files/content/surface_bad/rain_materials.lua")
local rain_material_list = {}
for k, _ in pairs(rain_material_data) do
	rain_material_list[#rain_material_list + 1] = k
end

--- @class surface_bad
--- @field rain_current_material string?
local surface_bad = {
	rain_current_material = nil,
	rain_duration = 0,
	rain_start_count = 0,
}

function surface_bad:init()
	ModLuaFileAppend(
		"data/scripts/biomes/mountain/mountain_top.lua",
		"mods/noita.fairmod/files/content/surface_bad/mountain_append.lua"
	)
	ModLuaFileAppend(
		"data/scripts/biomes/mountain_lake.lua",
		"mods/noita.fairmod/files/content/surface_bad/mountain_lake_append.lua"
	)

	local animal_spawner = nxml.new_element("VegetationComponent", {
		tree_probability = "0.9",
		rand_seed = "8674.1",
		tree_width = "30",
		is_visual = "1",
		tree_extra_y = "-50",
		load_this_xml_instead = "mods/noita.fairmod/files/content/surface_bad/surface_spawner.xml",
		tree_image_visual = "",
	})
	local propane_spawner = nxml.new_element("VegetationComponent", {
		tree_probability = "0.1",
		rand_seed = "1234",
		tree_width = "20",
		visual_offset_y = "-3",
		is_visual = "1",
		load_this_xml_instead = "mods/noita.fairmod/files/content/surface_bad/propane_mine_field/propane_mine.xml",
	})

	for _, biome in ipairs(peaceful_biomes) do
		for xml in nxml.edit_file(biome) do
			local mats = xml:first_of("Materials")
			if mats then mats:add_child(animal_spawner) end
		end
	end
	for xml in nxml.edit_file("data/biome/winter.xml") do
		local mats = xml:first_of("Materials")
		if mats then
			mats:add_child(animal_spawner)
			mats:add_child(propane_spawner)
		end
	end
end

function surface_bad:spawn()
	self.rain_start_count = GameGetFrameNum() - 500
end

--- Do rain thing
--- @return boolean
function surface_bad:rain_active()
	if not self.rain_current_material then return false end
	self.rain_duration = self.rain_duration - 1
	if self.rain_duration < 1 then
		self.rain_current_material = nil
		return false
	end

	local player_id = EntityGetWithTag("player_unit")[1] or EntityGetWithTag("polymorphed_player")[1]
	if not player_id then return true end

	local x, y = EntityGetTransform(player_id)
	local visibility = GameGetSkyVisibility(x, y)
	if visibility < 0.1 then return true end

	local mat = rain_material_data[self.rain_current_material]
	local emitter_e = EntityCreateNew("fairmod_fake_rain")
	EntityAddComponent2(emitter_e, "ParticleEmitterComponent", {
		emitted_material_name = self.rain_current_material,
		create_real_particles = true,
		x_pos_offset_min = -600,
		x_pos_offset_max = 600,
		y_pos_offset_min = -100,
		y_pos_offset_max = 100,
		draw_as_long = mat.draw_as_long or true,
		y_vel_min = mat.y_vel_min or 1000,
		y_vel_max = mat.y_vel_max or 1000,
		count_min = mat.count_min or 10,
		count_max = mat.count_max or 15,
	})
	EntityAddComponent2(emitter_e, "LifetimeComponent", {
		lifetime = 30,
	})
	EntitySetTransform(emitter_e, x, y - 500)

	return true
end

function surface_bad:update()
	if self:rain_active() then return end

	SetRandomSeed(GameGetFrameNum(), GameGetRealWorldTimeSinceStarted())
	self.rain_start_count = self.rain_start_count + Random(1, 10)

	if self.rain_start_count > 400 then
		self.rain_current_material = rain_material_list[Random(1, #rain_material_list)]
		self.rain_duration = Random(30, 90)
		self.rain_start_count = 0
	end
end

return surface_bad
