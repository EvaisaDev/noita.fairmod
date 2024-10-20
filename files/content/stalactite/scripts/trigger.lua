dofile_once("data/scripts/lib/utilities.lua")

last_trigger = last_trigger or -12352

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local variable_storage_comps = EntityGetComponent(entity_id, "VariableStorageComponent")

local offset_x = 0
local offset_y = 0
local projectile = ""

if variable_storage_comps ~= nil then
	for key, comp_id in pairs(variable_storage_comps) do
		local name = ComponentGetValue2(comp_id, "name")
		if name == "offset_x" then
			offset_x = ComponentGetValue2(comp_id, "value_int")
		elseif name == "offset_y" then
			offset_y = ComponentGetValue2(comp_id, "value_int")
		elseif name == "projectile" then
			projectile = ComponentGetValue2(comp_id, "value_string")
		end
	end
end

local function trigger(colliding_entity_id)
	local collider_x, collider_y = EntityGetTransform(colliding_entity_id)
	SetRandomSeed(x + collider_x, y + collider_y + GameGetFrameNum())

	last_trigger = GameGetFrameNum()

	local entity = shoot_projectile(entity_id, projectile, x, y + offset_y + 2, 0, 300, false)

	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/misc/poof.xml", x, y)

	local physics_body_component = EntityGetFirstComponent(entity, "PhysicsBodyComponent")

	if physics_body_component ~= nil then
		local x, y, angle, vel_x, vel_y, angular_vel = PhysicsComponentGetTransform(physics_body_component)
		PhysicsComponentSetTransform(physics_body_component, x, y, angle, 0, 25, angular_vel)
	end

	EntityKill(entity_id)
end

local trigger_width = 16

if GameGetFrameNum() - last_trigger < 60 then return end

local trigger_potential = {
	{
		tag = "player_unit",
		distance = 200,
		chance = 20,
	},
	{
		tag = "polymorphed_player",
		distance = 200,
		chance = 20,
	},
	{
		tag = "enemy",
		distance = 200,
		chance = 3,
	},
	{
		tag = "player_projectile",
		distance = 40,
		chance = 70,
	},
}

local potential_triggers = {}

local trigger_center_x = x + offset_x

for _, potential in ipairs(trigger_potential) do
	local entities = EntityGetInRadiusWithTag(x, y, potential.distance, potential.tag) or {}
	for _, entity in ipairs(entities) do
		table.insert(potential_triggers, { potential, entity })
	end
end

-- check if they are in the aabb
for _, trigger_t in ipairs(potential_triggers) do
	local entity = trigger_t[2]
	local ex, ey = EntityGetTransform(entity)
	local potential = trigger_t[1]

	if ex > trigger_center_x - (trigger_width / 2) and ex < trigger_center_x + (trigger_width / 2) then
		if ey >= y and ey <= y + potential.distance then
			SetRandomSeed(ex, ey)
			if Random(1, 100) <= potential.chance then
				trigger(entity)
				return
			end
		end
	end
end
