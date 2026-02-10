dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local function escape(str) return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1") end

string.modify = function(s, pattern, repl, n)
	return s:gsub("\r\n", "\n"):gsub(escape(pattern):gsub("\r\n", "\n"), repl, n)
end

local function modify_text_file(path, pattern, repl, n)
	ModTextFileSetContent(path, ModTextFileGetContent(path):modify(pattern, repl, n))
end

local set_file = ModTextFileSetContent
local get_file = ModTextFileGetContent

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml


--#region MISC/SMALL STUFF

modify_text_file("data/entities/animals/boss_alchemist/boss_alchemist_sprite.xml",
	"data/entities/animals/boss_alchemist/boss_alchemist.png", "mods/noita.fairmod/files/content/better_bosses/boss_alchemist.png"
)

--#endregion

--#region MASTER OF MASTERS

set_file("data/entities/animals/boss_wizard/bloodtentacle.lua",
	get_file("data/entities/animals/boss_wizard/bloodtentacle.lua")
		:modify("for i=1,2 do", "for i=1,4 do"
	)
)

set_file("data/entities/animals/boss_wizard/init.lua",
	get_file("data/entities/animals/boss_wizard/init.lua")
		:modify("for i=1,8 do", "SetRandomSeed(y, entity_id - x); for i=1,24 do")
		:modify("if ( i % 2 == 0 ) then", "if ( i == 1 or Random(0, 100) > 50 ) then"
	)
)

set_file("data/entities/animals/boss_wizard/laser.lua",
	get_file("data/entities/animals/boss_wizard/laser.lua")
		:modify("if ( #test < 6 ) then", "if ( #test < 12 ) then")
		:modify("for i=1,3 do", "for i=1,8 do")
		:modify("local arc = (math.pi * 2 / 3) * (i-1) + r", "local arc = (math.pi * 2 / 8) * (i-1) + r"
	)
)

local new_dist_stuff = [[local dir = inc * id + GameGetFrameNum() * 0.01
	
	local distance = 50

	if id %% 2 == 0 then
		distance = 60
	end]]

set_file("data/entities/animals/boss_wizard/orb_rotation.lua",
	get_file("data/entities/animals/boss_wizard/orb_rotation.lua")
		:modify("local count = 8", "local count = 24")
		:modify("local dir = inc * id + GameGetFrameNum() * 0.01", new_dist_stuff)
		:modify("( dir ) * 50", "( dir ) * distance"
	)
)

set_file("data/entities/animals/boss_wizard/statusburst.lua",
	get_file("data/entities/animals/boss_wizard/statusburst.lua")
		:modify("for i=1,2 do", "for i=1,6 do"
	)
)
--#endregion

--#region SQUIDWARD (REAL)
set_file("data/entities/animals/boss_pit/body.xml", get_file("mods/noita.fairmod/files/content/better_bosses/squidward/sprite_override.xml"))
set_file("data/entities/animals/boss_pit/boss_pit_damage.lua", get_file("mods/noita.fairmod/files/content/better_bosses/squidward/damage_override.lua"))

ReplaceImage("data/entities/animals/boss_pit/boss_pit.png", "mods/noita.fairmod/files/content/better_bosses/squidward/squidward.png")

for xml in nxml.edit_file("data/entities/animals/boss_pit/boss_pit.xml") do
	xml:add_child(nxml.new_element(
		"Entity",
		{name = "boss_pit_invincible"},
		{
			nxml.new_element("InheritTransformComponent"),
			nxml.new_element("GameEffectComponent", {
				_tags = "protection_all_short,effect_protection_all",
				effect = "PROTECTION_ALL",
				frames = -1,
			})
		}
	))
end

modify_text_file("data/entities/animals/boss_pit/boss_pit.xml", "\"slime_green\"", "\"magic_liquid_weakness\"")


local grab_invincibility_entity =
[[local children = EntityGetAllChildren( entity_id ) or {}
for a,b in ipairs( children ) do
	local effectname = EntityGetName( b )

	if ( effectname == "boss_pit_invincible" ) then
		local effectcomp = EntityGetFirstComponentIncludingDisabled( b, "GameEffectComponent")
		EntitySetComponentIsEnabled( entity_id, effectcomp, false)
		break
	end
end

EntitySetComponentsWithTagEnabled( entity_id, "invincible", false )]]

local modify_firerate =
[[		local luacomp = EntityGetFirstComponentIncludingDisabled( wid, "LuaComponent" )
		local fire_rate = 30
		if ( spells[rnd] == "rubber_ball" ) then
			fire_rate = 4
		elseif ( spells[rnd] == "grenade" ) or ( spells[rnd] == "rocket" ) then
			fire_rate = 10
		elseif ( spells[rnd] == "grenade_tier_2" ) then
			fire_rate = 15
		elseif ( spells[rnd] == "rocket_tier_2" ) then
			fire_rate = 20
		end
		ComponentSetValue2( luacomp, "execute_every_n_frame", fire_rate )
		
		EntityAddComponent( wid, "HomingComponent",]]


local summon_gun_barrage_patt = [[value_float = 1.2,
			} )
		end
	end]]

local summon_gun_barrage_repl = [[value_float = 2.0,
			} )
		end
	else
		local cid = EntityLoad( "mods/noita.fairmod/files/content/better_bosses/squidward/gun_stuff/gun_barrage_setup.xml", x, y )
		EntityAddChild( entity_id, cid )
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "squiwart/americano", x, y)
	end]]

set_file("data/entities/animals/boss_pit/boss_pit_logic.lua",
	get_file("data/entities/animals/boss_pit/boss_pit_logic.lua")
		:modify("EntitySetComponentsWithTagEnabled( entity_id, \"invincible\", false )", grab_invincibility_entity)
		:modify("if ( #p > 0 ) then", "if ( #p > 0 ) and ( Random( 1, 5 ) ~= 5 ) then")
		:modify("EntityAddComponent( wid, \"HomingComponent\",", modify_firerate)
		:modify(summon_gun_barrage_patt, summon_gun_barrage_repl
	)
)


local cheesy_check_patt = [[p_n = ComponentGetValue2( v, "value_string" )
			end
		end
	end]]

local cheesy_check_repl = [[p_n = ComponentGetValue2( v, "value_string" )
			end
		end
		local lasercomps = EntityGetComponent( p, "LaserEmitterComponent" )
		if ( lasercomps ~= nil ) then
			cheesy = true
		end
	end]]

set_file("data/entities/animals/boss_pit/boss_pit_memory.lua",
	get_file("data/entities/animals/boss_pit/boss_pit_memory.lua")
		:modify("local p_n = \"\"", "local p_n = \"\"\n\tlocal cheesy = false")
		:modify(cheesy_check_patt, cheesy_check_repl)
		:modify("ComponentSetValue2( v, \"value_string\", p_n )",
			"ComponentSetValue2( v, \"value_string\", p_n )\n\t\t\t\t\tComponentSetValue2( v, \"value_bool\", cheesy )"
	)
)
--#endregion

--#region KOLMISILMÄ
set_file("data/entities/animals/boss_centipede/body.xml", get_file("mods/noita.fairmod/files/content/better_bosses/kolmi/sprite_override.xml"))
modify_text_file("data/entities/animals/boss_centipede/body.xml",
	"data/entities/animals/boss_centipede/body.png", "mods/noita.fairmod/files/content/better_bosses/kolmi/kolmi.png"
)

for xml in nxml.edit_file("data/entities/animals/boss_centipede/body.xml") do
	xml:add_child(nxml.new_element("RectAnimation", {
		name="bite",
		pos_x="0",
		pos_y="576",
		frame_count="7",
		frame_width="96",
		frame_height="96",
		frame_wait="0.09",
		frames_per_row="7",
		next_animation="stand",
		loop="0"
	}))
end

--override entire file to grant more freedom over modifications and whatnot
modify_text_file("data/entities/animals/boss_centipede/boss_centipede.xml",
	"data/entities/animals/boss_centipede/boss_centipede_update.lua", "mods/noita.fairmod/files/content/better_bosses/kolmi/update.lua"
)

--larger chunks to block the lava into the arena
modify_text_file("data/entities/animals/boss_centipede/loose_lavaceiling.xml",
	"data/procedural_gfx/collapse_lavabridge/small_$[0-4].png", "data/procedural_gfx/collapse_lavabridge/$[0-4].png"
)
--#endregion

--this was annoying to write, nor does it look particularly good, i just need to remove all datafiling to do a couple things i wanna do