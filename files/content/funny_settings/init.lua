local function escape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

local shader_append = function(find, append)
	local path = "data/shaders/post_final.frag"

	-- add to next line
	local file = ModTextFileGetContent(path)
	local pos = string.find(file, escape(find))
	if pos then
		local pos2 = string.find(file, "\n", pos)
		if pos2 then
			local before = string.sub(file, 1, pos2)
			local after = string.sub(file, pos2 + 1)
			ModTextFileSetContent(path, before .. append .. after)
		end
	end
end

shader_append(
	"varying vec2 tex_coord_fogofwar;",
	[[
uniform vec4 COLORBLIND_MODE_ON;
uniform vec4 INVERT_Y_AXIS_ON;
uniform vec4 LOWER_RESOLUTION_RENDERING_ON;
uniform vec4 _8_BIT_COLOR_ON;
	]]
)

shader_append(
	"gl_FragColor.a = 1.0;",
	[[
	if(COLORBLIND_MODE_ON.x == 1.0) {
		vec3 color = pow(gl_FragColor.rgb, vec3(2.0));
		// grayscale conversion
		float gray = dot(color, vec3(0.2126, 0.7152, 0.0722));
		// regamma
		float gammaGray = sqrt(gray);
		gl_FragColor.rgb = vec3(gammaGray, gammaGray, gammaGray);
	}
	if(_8_BIT_COLOR_ON.x == 1.0) {
		gl_FragColor.r = floor(gl_FragColor.r * 3.0) / 3.0;
		gl_FragColor.g = floor(gl_FragColor.g * 7.0) / 7.0;
		gl_FragColor.b = floor(gl_FragColor.b * 7.0) / 7.0;
	}
]]
)

shader_append(
	"vec2 tex_coord_glow = tex_coord_glow_;",
	[[
	if(INVERT_Y_AXIS_ON.x == 1.0) {
		tex_coord = vec2(tex_coord.x, 1.0 - tex_coord.y);
	}
	if(LOWER_RESOLUTION_RENDERING_ON.x == 1.0) {

		float resolution_factor = 0.5;
		vec2 screen_size = vec2(SCREEN_W, SCREEN_H) * resolution_factor;

		tex_coord = vec2(floor(tex_coord.x * screen_size.x) / screen_size.x, floor(tex_coord.y * screen_size.y) / screen_size.y);
		tex_coord_y_inverted = vec2(floor(tex_coord_y_inverted.x * screen_size.x) / screen_size.x, floor(tex_coord_y_inverted.y * screen_size.y) / screen_size.y);
		tex_coord_glow = vec2(floor(tex_coord_glow.x * screen_size.x) / screen_size.x, floor(tex_coord_glow.y * screen_size.y) / screen_size.y);

	}
]]
)

local module = {}

module.OnPausedChanged = function()
	local colorblind_mode = ModSettingGet("noita.fairmod.colorblind_mode")
	if colorblind_mode then
		GameSetPostFxParameter("COLORBLIND_MODE_ON", 1, 0, 0, 0)
	else
		GameSetPostFxParameter("COLORBLIND_MODE_ON", 0, 0, 0, 0)
	end

	local invert_y_axis = ModSettingGet("noita.fairmod.invert_y_axis")
	if invert_y_axis then
		GameSetPostFxParameter("INVERT_Y_AXIS_ON", 1, 0, 0, 0)
	else
		GameSetPostFxParameter("INVERT_Y_AXIS_ON", 0, 0, 0, 0)
	end

	local lower_resolution_rendering = ModSettingGet("noita.fairmod.lower_resolution_rendering")
	if lower_resolution_rendering then
		GameSetPostFxParameter("LOWER_RESOLUTION_RENDERING_ON", 1, 0, 0, 0)
	else
		GameSetPostFxParameter("LOWER_RESOLUTION_RENDERING_ON", 0, 0, 0, 0)
	end

	local _8_bit_color = ModSettingGet("noita.fairmod.8_bit_color")
	if _8_bit_color then
		GameSetPostFxParameter("_8_BIT_COLOR_ON", 1, 0, 0, 0)
	else
		GameSetPostFxParameter("_8_BIT_COLOR_ON", 0, 0, 0, 0)
	end
end

module.OnPlayerSpawned = function(player)
	module.OnPausedChanged()

	if GameHasFlagRun("fairmod_init") then return end

	EntityAddComponent2(player, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/funny_settings/scripts/player_update.lua",
		execute_every_n_frame = 1,
		execute_on_added = true,
	})
end

return module
