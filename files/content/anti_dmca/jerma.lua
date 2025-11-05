last_blink = last_blink or 0
next_blink = next_blink or 60

local entity_id = GetUpdatedEntityID()

if GameGetFrameNum() > last_blink + next_blink then
	EntitySetComponentsWithTagEnabled(entity_id, "eyes", false)

    SetRandomSeed(-45 + last_blink, 8439 - next_blink)
	last_blink = GameGetFrameNum()
	next_blink = Random(150, 300)
elseif GameGetFrameNum() > last_blink + 15 then
	EntitySetComponentsWithTagEnabled(entity_id, "eyes", true)
end

local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35

local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)


function interacting(entity_who_interacted, entity_interacted, interactable_name)
	EntityLoad("mods/noita.fairmod/files/content/anti_dmca/jerma_run.xml", x, y)
	EntityKill(entity_id)
end