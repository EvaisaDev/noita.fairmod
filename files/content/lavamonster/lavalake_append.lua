local old_spawn_music_trigger = spawn_music_trigger
function spawn_music_trigger(...)
  local x, y = ...
  EntityLoad("mods/noita.fairmod/files/content/lavamonster/lavamonster.xml", x + 500, y + 100)
  -- To visualize the spawn location:
  -- GameCreateSpriteForXFrames("data/debug/circle_16.png", x + 500, y + 100, true, 0, 0, 100000)
  return old_spawn_music_trigger(...)
end
