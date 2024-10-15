local dialog_system = dofile_once("mods/DialogSystem_example/lib/DialogSystem/dialog_system.lua")
dialog_system.images.ruby = "mods/DialogSystem_example/files/ruby.png" -- This is how you add custom icons to be used by the img command
dialog_system.sounds.tick = { bank = "data/audio/Desktop/ui.bank", event = "ui/button_select" } -- This is how you add custom typing sounds

-- Make NPC stop walking while player is close
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local player = EntityGetInRadiusWithTag(x, y, 15, "player_unit")[1]
local character_platforming_component = EntityGetFirstComponentIncludingDisabled(entity_id, "CharacterPlatformingComponent")
if player then
  ComponentSetValue2(character_platforming_component, "run_velocity", 0)
else
  ComponentSetValue2(character_platforming_component, "run_velocity", 30)
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
  -- dialog_system.dialog_box_y = 10 -- Optional
  -- dialog_system.dialog_box_width = 300 -- Optional
  -- dialog_system.dialog_box_height = 70 -- Optional
  -- dialog_system.distance_to_close = 15 -- Optional
  dialog = dialog_system.open_dialog({
    name = "Morshu",
    portrait = "mods/DialogSystem_example/files/morshu/portrait.xml",
    animation = "morshu", -- Which animation to use
    typing_sound = "two", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
    text = [[
      Normal text, pause for 60 frames: {@pause 60}{@delay 10}Slow text{@delay 3}{@color FF0000} text color{@color FFFFFF}
      *Blinking text*, #shaking text#, ~rainbow wave text~, ~*#combined#*~
      {@sound tick}You can even use custom icons/images! {@img ruby}{@img ruby}{@img ruby}
      Which also support all modifiers: #{@img ruby}#*{@img ruby}*~{@img ruby}~~*#{@img ruby}#*~
    ]],
    options = {
      {
        text = "Buy potion (500 gold)",
        enabled = function(stats)
          -- stats is an object that provides convenient access to common values of the player, like gold, hp, max_hp
          return stats.gold >= 500
        end,
        func = function(dialog)
          dialog.show({
            -- Omitted properties will be inherited from the previous dialog
            name = "Noita",
            portrait = "mods/DialogSystem_example/files/wizard_portrait.png",
            text = "One potion please!",
            options = {
              {
                text = "Take potion",
                func = function(dialog)
                  -- Spawn a potion and add it to the inventory of the player
                  local potion = EntityLoad("data/entities/items/pickup/potion.xml")
                  GamePickUpInventoryItem(entity_who_interacted, potion)
                  -- And deduct 500 gold
                  local wallet_component = EntityGetFirstComponentIncludingDisabled(entity_who_interacted, "WalletComponent")
                  ComponentSetValue2(wallet_component, "money", ComponentGetValue2(wallet_component, "money") - 500)
                  dialog.close()
                end
              }
            }
          })
        end
      },
      {
        text = "An option without a 'func' property closes the dialog",
      },
    }
  })
end
