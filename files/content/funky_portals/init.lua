local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local init = {}
function init.OnMagicNumbersAndWorldSeedInitialized()

	for entity_xml in nxml.edit_file("data/entities/buildings/teleport_liquid_powered.xml") do
		entity_xml:add_child(nxml.new_element("LuaComponent", {
			script_source_file = "mods/noita.fairmod/files/content/funky_portals/portal_handler.lua",
			execute_on_added = "1",
			execute_times = "1"
		}))
	end

end

function init.OnPlayerSpawned(player)
	EntityAddComponent2(player, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/funky_portals/teleported_find_spot.lua",
		script_teleported = "mods/noita.fairmod/files/content/funky_portals/teleported_find_spot.lua",
		execute_on_added = true,
		execute_every_n_frame = 1,
	})
end



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

-- Shader stolen from https://www.shadertoy.com/view/ftVfzh
shader_append("varying vec2 tex_coord_fogofwar;", [[
/* VARIABLES */
#define END_ZOOM 0.0005
#define END_SPEED 0.002
#define END_LIGHT 1.4
uniform sampler2D END_TEXTURE;

/* CONST */
#define END_PI   3.14159265359
#define END_PI2  1.57079632679
#define END_PI4  0.78539816339
#define END_PI6  0.52359877559
#define END_PI8  0.39269908169
#define END_PI16 0.19634954084
#define END_PI32 0.09817477042

mat2 rotate2d(float _angle){
    return mat2(
        cos(_angle),-sin(_angle),
        sin(_angle),cos(_angle)
    );
}


vec4 render_pic_layer(vec2 fragCoord, vec3 color, float direction, float scale )
{
  vec2 size_image = vec2(END_ZOOM*scale, END_ZOOM*scale);
  vec2 uv = fragCoord/size_image; // Normalized pixel coordinates (from 0 to 1)
  
  uv *= rotate2d(direction);
  uv += vec2(0.0,-1.0) * END_SPEED * scale * time;
  
  vec4 col = texture2D(END_TEXTURE, uv);

  return vec4(col) * vec4(color, 1.0); // Output to screen
}
]])

shader_append("gl_FragColor.a = 1.0;", [[
	vec2 tex_coord_inverted = vec2(tex_coord.x, 1.0 - tex_coord.y);
	vec4 end_color_ref = texture2D(tex_fg, tex_coord_inverted );

	if (end_color_ref.r > 152.0 / 255.0 && end_color_ref.r < 154.0 / 255.0 && 
		end_color_ref.g > 54.0 / 255.0 && end_color_ref.g < 56.0 / 255.0 &&
		end_color_ref.b > 198.0 / 255.0 && end_color_ref.b < 200.0 / 255.0) {

		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
		tex_coord /= window_size.xy;
		tex_coord.x *= window_size.x/window_size.y;

		gl_FragColor += render_pic_layer(tex_coord, vec3(0.09, 0.22, 0.44), END_PI2+END_PI32, 2.2);
		gl_FragColor += render_pic_layer(tex_coord, vec3(0.20, 0.28, 0.29), END_PI-END_PI8, 1.3);
		gl_FragColor += render_pic_layer(tex_coord, vec3(0.07, 0.20, 0.21), END_PI +1.0*END_PI4, 1.0);
		gl_FragColor += render_pic_layer(tex_coord, vec3(0.16, 0.17, 0.20), END_PI16, 0.8);
		
		gl_FragColor += render_pic_layer(tex_coord, vec3(0.16, 0.13, 0.18), -END_PI4, 0.9);
		gl_FragColor += render_pic_layer(tex_coord, vec3(0.16, 0.13, 0.18), END_PI2-END_PI6, 0.3);
		gl_FragColor += render_pic_layer(tex_coord, vec3(0.16, 0.13, 0.18), END_PI32, 0.2);
		gl_FragColor += render_pic_layer(tex_coord, vec3(0.16, 0.13, 0.18), END_PI, 0.1);
		
		gl_FragColor *= END_LIGHT;

		
	}
]])

GameSetPostFxTextureParameter("END_TEXTURE", "mods/noita.fairmod/files/content/funky_portals/end.png", 2, 3)


-- doing this fixes the color channels for some reason
local _, _, _ = ModImageMakeEditable("mods/noita.fairmod/files/content/funky_portals/end.png", 0, 0)


return init

