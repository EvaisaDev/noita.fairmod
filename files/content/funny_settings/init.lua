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
