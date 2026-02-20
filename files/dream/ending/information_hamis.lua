local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.dialog_box_height = 80


local controls_comp_fields = {
	"mButtonDownLeft",
	"mButtonDownRight",
	"mButtonDownUp",
	"mButtonDownFly",
	"mButtonDownDown",
	"mButtonDownFire",
	"mButtonDownFire2",
	"mButtonDownThrow",
	"mButtonDownInteract",
}

local function set_controls_enabled(val)
	local player = EntityGetWithTag("player_unit")[1]
	if not player then return end
	local controls_component = EntityGetFirstComponent(player, "ControlsComponent")
	if not controls_component then return end
	ComponentSetValue2(controls_component, "enabled", val)
	for _, field in ipairs(controls_comp_fields) do
		ComponentSetValue2(controls_component, field, val)
	end
end

function interacting(player, entity_id, interaction)
	if EntityHasTag(player, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") or GameHasFlagRun("holding_interactible") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")
    set_controls_enabled(false)

    dialog = dialog_system.open_dialog({
		name = "Information Hämis",
		portrait = "mods/noita.fairmod/files/content/information_kiosk/portrait.png",
        text = "Well{@pause 10} that was a nice break,{@pause 10} a good chance to stretch my legs!{@pause 80}\nWelp,{@pause 20} lets back to it!",
		options = {
            {
                text = "what.",
            },
			{
				text = "Ask for a tip",
				func = function(dialog)
					dialog.show({
						text = "{@delay 2}Hm?{@pause 30} Sure,{@pause 5} why not,{@pause 20} this one's on the house!{@pause 60}\nThe Fairmod is Eternal,{@pause 15} you can never leave.",
                        func = function() AddFlagPersistent("fairmod_lovely_dream_hamis_tip") end,
						options = {
							{
								text = "Accept your fate",
							},
						},
					})
				end,
			},
        },
		on_closed = function()
			GameRemoveFlagRun("fairmod_dialog_interacting")
			AddFlagPersistent("fairmod_won_lovely_dream")
			set_controls_enabled(true)
		end,
    })
end