
local COOLDOWN = 600
local last_frame_num = 0

function collision_trigger(colliding_entity_id)
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	local current_frame_num = GameGetFrameNum()
	if current_frame_num - last_frame_num < COOLDOWN then
		return
	end
	last_frame_num = current_frame_num

	EntityLoad("data/entities/props/physics/minecart.xml", x - 210, y - 240)
end
