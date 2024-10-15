# DialogSystem for Noita
An example mod that uses this library can be downloaded here: https://github.com/TheHorscht/DialogSystem_example/releases
## Installation
Copy the files into your mod, so the structure looks like this: `mods/yourmod/lib/DialogSystem/dialog_system.lua`

Then in your mod's init.lua, initialize the library like this:
```lua
dofile_once("mods/yourmod/lib/DialogSystem/init.lua")("mods/yourmod/lib/DialogSystem")
```
Passing in the path to to the folder containing `dialog_system.lua`.
### Global config
You can also pass in a table with configuration options as the second parameter to the init function:
```lua
dofile_once("mods/yourmod/lib/DialogSystem/init.lua")("mods/yourmod/lib/DialogSystem", {
  disable_controls = true,
  images = {
    -- To be used with {@img something} in dialog text
    something = "mods/yourmod/files/dialog_images/something.png",
    something_else = "mods/yourmod/files/dialog_images/something_else.png",
  },
  sounds = {
    -- Can then be specified as typing_sound = "new_sound"
    new_sound = { bank = "mods/yourmod/files/dialog_sounds.bank", event = "cool_new_sound" },
    new_sound_two = { bank = "mods/yourmod/files/dialog_sounds.bank", event = "cool_new_sound2" },
  },
})
```
## Quick start
Create a new entity with a LuaComponent as follows:
```xml
<LuaComponent
  script_interacting="mods/yourmod/files/npc/interact.lua"
  script_source_file="mods/yourmod/files/npc/interact.lua"
  execute_every_n_frame="1"
  enable_coroutines="1"
  >
</LuaComponent>
```
```lua
-- mods/yourmod/files/npc/interact.lua
local dialog_system = dofile_once("mods/yourmod/lib/DialogSystem/dialog_system.lua")

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
  dialog_system.open_dialog({
    name = "Monkey",
    portrait = "mods/yourmod/files/npc/portraits/monkey.png",
    typing_sound = "one",
    text = "Hello, I am monkey! Would you like to buy a banana?",
    options = {
      {
        text = "Oh yes please! (500 gold)",
        func = function(dialog)
          spawn_banana_at_player_position() -- You implement this yourself :)
          reduce_player_gold(500) -- You implement this yourself :)
          dialog.show({
            -- Options that are not specified will use the previous messages options
            text = "Thanks for the purchase buddy.",
          })
        end
      },
      {
        text = "Nah I'm not hungry.",
        -- If no func is specified, the option will close the dialog
      },
    }
  })
end
```
## Documentation
```lua
-- Dofile-ing dialog_system.lua returns the dialog system
local dialog_system = dofile_once("mods/yourmod/lib/DialogSystem/dialog_system.lua")
```
It can either be configured locally by setting the following properties on it, or globally when initializing the library (see [here](#global-config)).
If nothing is configures, it will fall back to use the defaults.
```lua
-- To add new images/icons to be used in text, this one will be usable as {@img fish}
dialog_system.images.fish = "mods/yourmod/files/dialog_images/fish.png"
-- To add new typing sounds, to use it specify typing_sound = "tick" after registering it like this
dialog_system.sounds.tick = { bank = "mods/yourmod/files/audio/your_bank.bank", event = "sounds/my_cool_sound" }
 -- Distance from bottom of screen
dialog_system.dialog_box_y = 50
 -- How wide the dialog box is
dialog_system.dialog_box_width = 300
 -- How tall the dialog box is
dialog_system.dialog_box_height = 70
 -- How far the player has to move away from the point where it was opened for it to close automatically
 -- if not specified, uses the InteractableComponent:radius
dialog_system.distance_to_close = 15
-- Whether to disable the controls of the player while the dialog is open
dialog_system.disable_controls = false
```
**function** `dialog_system.open_dialog(message : message)` **returns** `dialog`

**type** `dialog` Contains functions relating to the whole dialog.

- **function** `dialog.close()` Closes the dialog.
- **function** `dialog.back()` Shows the previous message.
- **function** `dialog.show(message)` Switch to the specified dialog.
- **function** `dialog.is_too_far()` Returns `boolean` whether the player is too far from the point where the dialog was opened at.

**type** `message` Contains information what should be displayed in a dialog.
- **field** `name (string)` Will be displayed in the nameplate, if `nil` won't display one.
- **field** `text (string)` Text to display, whitespaces in front of each line will be trimmed, to make it easier to use multine strings.
- **field** `portrait (string)` File path to the portait to use, can be PNG or an animation/spritesheet XML. (Dimensions should be 64x64)
- **field** `animation (string)` When specifying an XML, specifies the animation to use.
- **field** `typing_sound (string)` Can choose between built ins ("one", "two", "three", "four", "sans").
- **field** `options (table[option])` Table of items of type `option`
- **field** `on_closing (function)` Will be called once the dialog starts closing.
- **field** `on_closed (function)` Will be called after the dialog has been closed.

**type** `option` A clickable option at the end of a dialog.
- **field** `text (string)` Will be displayed if the option is enabled.
- **field** `text_disabled (string)` Will be displayed if the option is disabled, if not provided, uses the same as `text`.
- **field** `enabled (function|boolean)` Function/boolean whether this option should be enabled. The function gets passed a table as it's first argument,
which allows for convenient access to common stats of the player like gold, hp etc. [See example](#option-enabled-function-example). The function will run once every 30 frames. Arguments: `(stats)`.
- **field** `func` The function which will be called when selecting the option, if omitted, will default to `dialog.close`. Arguments: `(dialog, stats)`.
## Option enabled function example:
```lua
enabled = function(stats)
  return stats.gold >= 100
end
```
### Text Format
The text you can display is very dynamic, you can use a multitude of different effects and commands to change the text speed, color, etc. 

The effects can be used like this:
- \*Text between asterisks will blink\*
- #Text between pound signs will shake#
- \~Text between tildes will have rainbow colors\~

Whereas commands are more elaborate and are used like this:
- `{@pause 60}` Stops advancing the text for 60 frames.
- `{@delay 10}` Sets the delay between typing of each character to 10 frames.
- `{@color FF0000}` Sets the text color to red. Format is in RGB hexadecimal.
- `{@img banana}` Display an icon/image registered on the `dialog_system` object.
- `{@sound tick}` Sets the typing sound to the specified sound.

# This library currently has no to very little error checking or reporting. So, uh just use it correctly!
