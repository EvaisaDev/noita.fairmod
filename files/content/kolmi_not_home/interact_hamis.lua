local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local text = {
	--[["...",
	"*The hämis is staring off into the distance*",
	"*Not a thought in its head*",
	"*This is not the bossfight you expected.*",]]
	"Thank you Mina! But our Kolmi is in another castle!",
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
				text = "Leave",
			},
		}
	})
end
