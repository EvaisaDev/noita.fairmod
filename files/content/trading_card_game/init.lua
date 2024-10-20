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

-- Shader stolen from https://www.shadertoy.com/view/MXS3WV
shader_append(
	"varying vec2 tex_coord_fogofwar;",
	[[
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
]]
)

shader_append(
	"gl_FragColor.a = 1.0;",
	[[

if(CARD_VISIBLE.x == 0.0) {
	return;
}
vec2 tex_coord_inverted_y = vec2(tex_coord.x, tex_coord.y);

// p is the screen coordinate, -1 ... +1
vec2 p = 2.0 * tex_coord_inverted_y - 1.0;
// Compensate for aspect ratio to make a square
p *= window_size.xy / min(window_size.x, window_size.y);
// Adjust to the aspect ratio of a TCG Card
p /= vec2(1, 1.5);
// Zoom out
p *= 2.0;

// Create a matrix to rotate our card
float g = 0.3 * -CARD_AIM_DIRECTION.x;
float h = 0.3 * -CARD_AIM_DIRECTION.y;
// Skew the texture2D to fake the effect of moving the camera
mat3 m = mat3(
    vec3(1, 0, g),
    vec3(0, 1, h),
    vec3(0, 0, 1)
);

// Create a new UV that's going to act as our skewed screen UV
vec2 rectUV = div_z((m * vec3(p, 1)));

// Create a UV that repeats across the plane,
// +0.5 to center a rect in the middle of the screen
vec2 tiledCoord = fract(rectUV + 0.5);

// Isolate the center rect; set to 1.0 to repeat the card across the plane
float isCenterRect = step(0.0, rectUV.x + 0.5) * step(rectUV.x + 0.5, 1.0) *
                     step(0.0, rectUV.y + 0.5) * step(rectUV.y + 0.5, 1.0);

// Create a rotation for our rainbow texture2D
// Faking the effect of light bouncing off our rect as a result of the norm changing
mat3 rotateUVMat = mat3(
    vec3(-CARD_AIM_DIRECTION.y, -CARD_AIM_DIRECTION.y, 0),
    vec3(CARD_AIM_DIRECTION.y, -CARD_AIM_DIRECTION.y, 0),
    vec3(0, 0, 1)
);

// Create a rotated UV of our rect
// Rotates around the bottom-left corner
vec2 rotatedRainbowUV = (rotateUVMat * vec3(tiledCoord, 1.0)).rg;

// Load in the dot pattern
// We'll use the dot pattern as a UV offset and scale down the intensity
vec2 dotPatternOffset = texture2D(DOT_TEXTURE, tiledCoord).rr * DOT_STRENGTH;

// Load in the rainbow texture, adding the dot as a UV offset
vec3 rainbow = texture2D(RAINBOW_TEXTURE, rotatedRainbowUV + dotPatternOffset).rgb;

// Load the card art texture including its alpha channel
vec4 cardArt = texture2D(CARD_ART_TEXTURE, tiledCoord);

// Determine where to apply the holographic effect based on brightness
float hologramMask = step(0.9, length(cardArt.rgb));

// Adjust the intensity of the holographic effect
float holographicIntensity = 0.5; // Adjust between 0.0 (no effect) and 1.0 (full effect)

// Combine the card art with the holographic effect, applying it selectively
vec3 combinedRGB = mix(cardArt.rgb, rainbow, hologramMask * holographicIntensity);

// Multiply by the card's alpha to maintain transparency
combinedRGB *= cardArt.a;

// Isolate the center rect and blend with the background color
vec4 backgroundColor = vec4(color, 1.0);
float mask = isCenterRect * cardArt.a;
gl_FragColor = mix(backgroundColor, vec4(combinedRGB, cardArt.a), mask);
]]
)

GameSetPostFxTextureParameter(
	"RAINBOW_TEXTURE",
	"mods/noita.fairmod/files/content/trading_card_game/gradient2.png",
	2,
	3
)
GameSetPostFxTextureParameter("DOT_TEXTURE", "mods/noita.fairmod/files/content/trading_card_game/dots.png", 2, 3)
GameSetPostFxTextureParameter(
	"CARD_ART_TEXTURE",
	"mods/noita.fairmod/files/content/trading_card_game/card_test.png",
	2,
	3
)

-- doing this fixes the color channels for some reason
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/gradient.png", 0, 0)
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/dots.png", 0, 0)
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/card.png", 0, 0)
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/trading_card_game/card_test.png", 0, 0)

dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local t = {}

t.update = function()
	local players = GetPlayers()

	if #players > 0 then
		--GameSetPostFxParameter("CARD_VISIBLE", 1, 0, 0, 0)

		local player = players[1]

		local controls_component = EntityGetFirstComponent(player, "ControlsComponent")
		if controls_component ~= nil then
			local dir_x, dir_y = ComponentGetValue2(controls_component, "mAimingVectorNormalized")

			GameSetPostFxParameter("CARD_AIM_DIRECTION", dir_x, dir_y, 0, 0)
		end
	else
		GameSetPostFxParameter("CARD_VISIBLE", 0, 0, 0, 0)
	end
end

return t
