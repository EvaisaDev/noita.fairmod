last_blink = last_blink or 0
next_blink = next_blink or 60

local entity_id = GetUpdatedEntityID()

if GameGetFrameNum() > last_blink + next_blink then
	EntitySetComponentsWithTagEnabled(entity_id, "eyes", false)

	last_blink = GameGetFrameNum()
	next_blink = Random(70, 200)
elseif GameGetFrameNum() > last_blink + 15 then
	EntitySetComponentsWithTagEnabled(entity_id, "eyes", true)
end