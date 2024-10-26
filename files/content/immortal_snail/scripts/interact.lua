local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
--dialog_system.images.ruby = "mods/DialogSystem_example/files/ruby.png" -- This is how you add custom icons to be used by the img command
--dialog_system.sounds.tick = { bank = "data/audio/Desktop/ui.bank", event = "ui/button_select" } -- This is how you add custom typing sounds

-- Make NPC stop walking while player is close
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local player = EntityGetInRadiusWithTag(x, y, 30, "player_unit")[1]

local current_potrait = tonumber(GlobalsGetValue("current_snail_potrait", "1"))

gun_was_given = gun_was_given or false
gun_triggered = gun_triggered or false

local give_gun = function()
	GameDestroyInventoryItems(entity_id)
	local entity = EntityLoad("mods/noita.fairmod/files/content/immortal_snail/gun/entities/items/glock.xml", x, y)
	GamePickUpInventoryItem(entity_id, entity, true)
	gun_was_given = true
end

if not player then
	GameRemoveFlagRun("pause_snail_ai")
	if gun_triggered and not gun_was_given then give_gun() end
end

local snail_dialog = {
	{
		text = [[
After looking at the snail for a moment you notice it is 
holding a kitchen knife! 
This snail might be out for blood.]],
		next = "I said. Inspect. The snail.",
	},
	{
		text = [[
Okay okay calm down.
After further inspection you actually notice the snail is 
holding a bunch of kitchen utensils.
Maybe this snail isn't so bad after all.]],
		next = "FURTHER INVESTIGATION.",
	},
	{
		text = [[
Alright, the snail is holding a gun. 
Better get going.]],
		close_func = function()
			give_gun()
		end,
		func = function(dialog)
			gun_triggered = true
		end,
	},
}

local open_dialog = function()
	dialog = dialog_system.open_dialog({
		name = "Snail",
		portrait = "mods/noita.fairmod/files/content/immortal_snail/sprites/snail_portrait_" .. tostring(
			current_potrait
		) .. ".png",
		typing_sound = "default", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
		text = [[
		The snail looks at you with #murderous# intent.
		]],
		options = {
			{
				text = "Inspect the snail.",
				enabled = function(stats)
					return current_potrait < 4
				end,
				func = function(dialog)
					-- keep dialog going
					dialogue_loop = function(dialog)
						local current_dialog = snail_dialog[current_potrait]
						current_potrait = current_potrait + 1
						GlobalsSetValue("current_snail_potrait", tostring(current_potrait))

						local options = {}

						if current_dialog.next then
							table.insert(options, { text = current_dialog.next, func = dialogue_loop })
						end

						if current_dialog.close_func then
							table.insert(options, {
								text = "Leave",
								func = function()
									current_dialog.close_func()
									dialog.close()
								end,
							})
						else
							table.insert(options, { text = "Leave" })
						end

						if current_dialog.func then current_dialog.func(dialog) end

						dialog.show({
							portrait = "mods/noita.fairmod/files/content/immortal_snail/sprites/snail_portrait_"
								.. tostring(current_potrait)
								.. ".png",
							text = current_dialog.text,
							options = options,
						})
					end

					dialogue_loop(dialog)
				end,
			},
			{
				text = "Trick or treat!",
				show = function()
					return GameHasFlagRun("fairmod_halloween_mask")
				end,
				func = function(dialog)
					dialog.show({
						portrait = "mods/noita.fairmod/files/content/immortal_snail/sprites/snail_portrait_4.png",
						text = "Trick.",
						options = {
							{
								text = "Run",
								func = function()
									gun_triggered = true
									give_gun()
								end,
							},
						},
					})
				end,
			},
			{
				text = "Leave",
			},
		},
	})
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	GameAddFlagRun("pause_snail_ai")

	open_dialog()
end
