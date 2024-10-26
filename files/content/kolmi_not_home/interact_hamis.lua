local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local text = {
	--[["...",
	"*The hämis is staring off into the distance*",
	"*Not a thought in its head*",
	"*This is not the bossfight you expected.*",]]
	"Thank you Minä! But our Kolmi is in another castle!",
}

SetRandomSeed(x + GameGetFrameNum(), y)

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	dialog = dialog_system.open_dialog({
		name = "Hämis",
		portrait = "mods/noita.fairmod/files/content/kolmi_not_home/hamis_portrait.png",
		typing_sound = "default", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
		text = text[Random(1, #text)],
		options = {
			{
				text = "Trick or treat!",
				show = function()
					return GameHasFlagRun("fairmod_halloween_mask")
				end,
				func = function(dialog)
					if tonumber(GlobalsGetValue("fairmod_hamis_candy_gotten", "0")) >= 15 then
						dialog.show({
							text = "I appear to be out of treats.. Sorryyy...",
							options = {
								{
									text = "Leave",
								},
							},
						})
					else
						dialog.show({
							text = "Cool costume!!\nMy mom said I didn't need one because\nI'm already really cute!!",
							options = {
								{
									text = "Take treat",
									func = function(dialog)
										SetRandomSeed(GameGetFrameNum() + y, y * x)

										CreateItemActionEntity(GetRandomAction(GameGetFrameNum(), y, 10, 1), x, y)
										GlobalsSetValue("fairmod_hamis_candy_gotten", tonumber(GlobalsGetValue("fairmod_hamis_candy_gotten", "0")) + 1)
								
										dialog.close()
									end,
								},
							},
						})

					end
				end,
			},
			{
				text = "Leave",
			},
		},
	})
end
