GamePrint("Fish activate")

local fish_entity = EntityGetParent(GetUpdatedEntityID())
if EntityGetIsAlive(fish_entity) then
	EntitySetComponentsWithTagEnabled(fish_entity, "activate", true)
end
