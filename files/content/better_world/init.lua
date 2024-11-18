--stylua: ignore start

local better_world = {}

dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local markers = dofile_once("mods/noita.fairmod/files/content/better_world/map_helper.lua")

local nxml = dofile("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local nil_pos = {x = 0, y = 0} --default thing so i dont have to keep writing this out


ModTextFileSetContent("data/scripts/newgame_plus.lua", ModTextFileGetContent("mods/noita.fairmod/files/content/better_world/ngplus_enter_override.lua"))
ModTextFileSetContent("data/biome_impl/biome_map_newgame_plus.lua", ModTextFileGetContent("mods/noita.fairmod/files/content/better_world/ngplus_biomes_override.lua"))



ModLuaFileAppend("data/scripts/biome_scripts.lua", "mods/noita.fairmod/files/content/better_world/biome_functions_append.lua")

do return end --lower stuff is unused for now since we've decided not to apply the world expansion to NG


------------------ MOVE SPLICED PIXEL SCENES ------------------

local spliced_cutscenes = {
    boss_arena = {
        marker = markers.boss_arena,
        filepath = "data/biome_impl/spliced/boss_arena.xml",
    },
    lake_statue = {
        marker = markers.lake_statue,
        filepath = "data/biome_impl/spliced/lake_statue.xml",
    },
}

for key, value in pairs(spliced_cutscenes) do
    for xml in nxml.edit_file(value.filepath) do
        local origin
        local marker = value.marker --just to make it a bit more readable
        for pixel_scene in xml:first_of("mBufferedPixelScenes"):each_of("PixelScene") do
            if origin == nil then origin = { x = pixel_scene.attr.pos_x , y = pixel_scene.attr.pos_y } end --get origin of base pixel scene to for offset
            pixel_scene.attr.pos_x = marker.x + (pixel_scene.attr.pos_x - origin.x) --offset is the pixel scene's old position relative to its origin
            pixel_scene.attr.pos_y = marker.y + (pixel_scene.attr.pos_y - origin.y)
        end
    end
end


------------------ PORTALS ------------------

local _pixel_scenes = { --index should be according to the line-number in "noita.fairmod/files/content/better_world/_pixel_scenes list (its handy trustm).xml"
    [3] = {
        marker = markers.hiisi_anvil,
    },
    [4] = {
        marker = markers.vault_entrance,
    },
    [6] = {
        marker = markers.tower_start,
    },
    [10] = {
        marker = markers.fishing_hut,
    },
    [17] = {
        marker = markers.fishing_hut, --bunker 1
        offset = { x = -3, y = 186 }
    },
    [18] = {
        marker = markers.fishing_hut, --bunker 2
        offset = { x = -353, y = 400 },
    },
    [56] = {
        marker = markers.fishing_hut, --hut check entity
        offset = { x = 159, y = 50 },
    },
    [91] = {
        marker = markers.big_fish,
    },
}

for xml in nxml.edit_file("data/biome/_pixel_scenes.xml") do --real handy that p much most of the non-spliced pixel scenes are in one file, if not all
    local i = 1
    for pixel_scene in xml:first_of("mBufferedPixelScenes"):each_of("PixelScene") do
        if _pixel_scenes[i] then
            local marker = _pixel_scenes[i].marker or nil_pos
            local offset = _pixel_scenes[i].offset or nil_pos
            pixel_scene.attr.pos_x = tostring(marker.x + offset.x)
            pixel_scene.attr.pos_y = tostring(marker.y + offset.y)
        end
        i = i + 1
    end
end


better_world.OnWorldInitialized = function()
    local new_pixel_scenes = {
        desert_ruined_temple = {
            materials = "mods/noita.fairmod/files/content/better_world/desert_teleport/desert_ruined_mountain.png",
            visual = "mods/noita.fairmod/files/content/better_world/desert_teleport/desert_ruined_mountain_visual.png",
            background = "mods/noita.fairmod/files/content/better_world/desert_teleport/desert_ruined_temple_background.png",
            location = markers.desert_ruined_temple,
            background_offset = { x = -1, y = 30 },
            pw_range = 4, --0 spawns it in no neighbouring PWs (1 spawn), 1 makes it spawn in neighbouring PWs (3 spawns), 2 spawns it in PWs neighbouring at a range of 2 (5 spawns), etc, you get it
        },
    }

    for key, value in pairs(new_pixel_scenes) do
        local location = value.location or nil_pos
        local pw_range = value.pw_range or 0
        local offset = value.background_offset
        if pw_range > 0 then
            for i = 0 - pw_range, pw_range do
                if value.background and offset then
                    LoadBackgroundSprite( "data/biome_impl/temple/wall_background.png", location.x + offset.x + (i * WORLD_WIDTH_HARDCODED), location.y + offset.y, 50 ) --nathan its my code, i can write it how i want
                end

                LoadPixelScene(value.materials, value.visual, location.x + (i * WORLD_WIDTH_HARDCODED), location.y, value.background or "")
            end
        else
            LoadPixelScene(value.materials, value.visual, location.x, location.y, value.background)
        end
    end
end


------------------ PORTALS ------------------

local portals = {
    tower_enter = {
        destination = markers.tower_start,
        filepath = "data/entities/buildings/mystery_teleport.xml",
        offset = { x = 64, y = 64 },
        make_pw_local = true --dexter apparently has his own PW-portal script so this is redundant, but shush i like my one (though i would recommend using his in general)
    },
    teleport_lake = {
        destination = markers.lake_statue,
        filepath = "data/entities/buildings/teleport_lake.xml",
        offset = { x = 1427, y = -20 },
    },
    bunker1 = {
        destination = markers.fishing_hut,
        filepath = "data/entities/buildings/teleport_bunker.xml",
        offset = { x = 200, y = 251},
    },
    bunker2 = {
        destination = markers.fishing_hut,
        filepath = "data/entities/buildings/teleport_bunker2.xml",
        offset = { x = -200, y = 475 },
    },
    bunker_back = {
        destination = markers.fishing_hut,
        filepath = "data/entities/buildings/teleport_bunker_back.xml",
        offset = { x = 43, y = 50 },
    },
}

for key, value in pairs(portals) do
    for xml in nxml.edit_file(value.filepath) do
        local offset = value.offset or nil_pos
        local tele_comp = xml:first_of("TeleportComponent")
        if tele_comp ~= nil then
            tele_comp.attr["target.x"] = value.destination.x + offset.x
            tele_comp.attr["target.y"] = value.destination.y + offset.y
        else
            print("TeleportComponent is nil on " .. key)
        end
        
        if value.make_pw_local then
            xml:add_child(nxml.new_element("LuaComponent", {
                execute_on_added = 1,
                remove_after_executed = 1,
                script_source_file = "mods/noita.fairmod/files/content/better_world/portal_scripts/parallel_portals.lua",
            }))
        end
    end
end

ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/noita.fairmod/files/content/better_world/snowcastle.lua") --remove safety region

return better_world
--stylua: ignore end