local entity = GetUpdatedEntityID()

if HasFlagPersistent("fairmod_saw_jungle_once") then
local x, y = EntityGetTransform(entity)
	EntityLoad("data/entities/props/root_grower.xml", x, y)
else
	AddFlagPersistent("fairmod_saw_jungle_once")
end
