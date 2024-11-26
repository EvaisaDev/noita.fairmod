
local function escape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

local shader_append = function(find, append)

	local path = "data/shaders/post_final.frag"

	-- add to next line
	local file = ModTextFileGetContent( path )
	local pos = string.find(file, escape(find))
	if pos then
		local pos2 = string.find(file, "\n", pos)
		if pos2 then
			local before = string.sub(file, 1, pos2)
			local after = string.sub(file, pos2 + 1)
			ModTextFileSetContent( path, before .. append .. after )
		end
	end
	

end

-- Shader stolen from https://www.shadertoy.com/view/MXS3WV
shader_append("varying vec2 tex_coord_fogofwar;", [[
uniform sampler2D RAINBOW_TEXTURE;
uniform sampler2D DOT_TEXTURE;
uniform sampler2D CARD_ART_TEXTURE;
uniform vec4 CARD_VISIBLE;
uniform vec4 CARD_AIM_DIRECTION;
#define DOT_STRENGTH 0.1

vec2 div_z(vec3 v)
{
    return vec2(v) / v.z;
}
]])

shader_append("gl_FragColor.a = 1.0;", ModTextFileGetContent("mods/noita.fairmod/files/content/trading_card_game/shader_append.txt"))

GameSetPostFxTextureParameter("RAINBOW_TEXTURE", "mods/noita.fairmod/files/content/trading_card_game/gradient2.png", 2, 3)
GameSetPostFxTextureParameter("DOT_TEXTURE", "mods/noita.fairmod/files/content/trading_card_game/dots.png", 2, 3)
GameSetPostFxTextureParameter("CARD_ART_TEXTURE", "mods/noita.fairmod/files/content/trading_card_game/card_test.png", 2, 3)

-- doing this fixes the color channels for some reason
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/gradient.png", 0, 0)
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/dots.png", 0, 0)
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/card.png", 0, 0)
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/card_test.png", 0, 0)

dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local t = {}

local function awesome_function_name(value)
	return value == 0 and 0 or value > 0 and 1 or -1
end

t.update = function()
	local players = GetPlayers()

	if(#players > 0)then
		GameSetPostFxParameter("CARD_VISIBLE", 1, 0, 0, 0)
		
		local player = players[1]

		local controls_component = EntityGetFirstComponent(player, "ControlsComponent")
		if(controls_component ~= nil)then
			local dir_x, dir_y = ComponentGetValue2(controls_component, "mAimingVectorNormalized")
			local distx,disty = ComponentGetValue2(controls_component, "mAimingVector")
			local multiplier = (math.sqrt((distx^2) + (disty^2))^.6) * .1
			
			
			GameSetPostFxParameter("CARD_AIM_DIRECTION", dir_x * multiplier, dir_y * multiplier, 0, 0)
		end
	else
		GameSetPostFxParameter("CARD_VISIBLE", 0, 0, 0, 0)
	end
end

return t