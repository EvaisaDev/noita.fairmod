dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), pos_x + pos_y + entity_id)

function bullet_circle(which, count, speed, animal_, gold_, direct_)
	local how_many = count or 4
	local angle_inc = (2 * 3.14159) / how_many
	local theta = rot
	local length = speed or 200
	local name = which or "buckshot"

	local animal = animal_ or false
	local gold = gold_ or false
	local direct = direct_ or false

	for i = 1, how_many do
		local vel_x = math.cos(theta) * length
		local vel_y = 0 - math.sin(theta) * length

		local target = "data/entities/projectiles/" .. name .. ".xml"
		if gold then target = "data/entities/items/pickup/" .. name .. ".xml" end
		if direct then target = name end

		local bid

		bid = shoot_projectile(entity_id, target, pos_x + math.cos(theta) * 12, pos_y - math.sin(theta) * 12, vel_x, vel_y)

		if (bid ~= nil) and animal then EntityAddComponent(bid, "VariableStorageComponent", {
			_tags = "no_gold_drop",
		}) end

		theta = theta + angle_inc
	end
end

local status = 0
local rstorage = 0

local variablestorages = EntityGetComponent(entity_id, "VariableStorageComponent")
if variablestorages ~= nil then
	for j, storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue(storage_id, "name")
		if var_name == "rolling" then
			status = ComponentGetValue2(storage_id, "value_int")
			rstorage = storage_id
		end
	end

	if status > 0 then
		status = status + 1

		if status >= 20 then
			local players = EntityGetInRadiusWithTag(pos_x, pos_y, 480, "player_unit")

			status = 0
			local result = Random(1, 6)
			local special = Random(1, 100)

			local textprint = "$item_die_"
			local anim = "default"

			if special < 100 then
				textprint = textprint .. tostring(result)

				if #players > 0 then GamePrint(textprint) end

				anim = "rolled_" .. tostring(result)

				if result <= 3 then
					local spells = {}

					function table.has_value(tab, val)
						for index, value in ipairs(tab) do
							if value == val then return true end
						end

						return false
					end

					dofile_once("data/scripts/gun/gun_actions.lua")

					for k, data in pairs(actions) do
						if data.related_projectiles ~= nil then
							if data.pandorium_ignore then goto continue end
							if data.tm_trainer and Randomf() >= (ModSettingGet("noita.fairmod.cpand_tmtrainer_chance") or 0) then goto continue end
							for k2, v in pairs(data.related_projectiles) do
								if ModDoesFileExist(v) then
									if table.has_value(spells, v) == false then table.insert(spells, v) end
								end
							end
						end
						::continue::
					end

					local spell = spells[Random(1, #spells)]

					bullet_circle(spell, Random(6, 10), 600, nil, nil, true)
				elseif result == 4 then
					bullet_circle("goldnugget_10", 16, 200, nil, true)
				elseif result == 5 then
					bullet_circle("goldnugget_50", 12, 200, nil, true)
				elseif result == 6 then
					bullet_circle("goldnugget_200", 8, 600, nil, true)
				end
			else
				textprint = "$item_greed_die_"

				if result <= 3 then
					textprint = textprint .. "bad"
					anim = "rolled_bad"
					bullet_circle("deck/disc_bullet_bigger", 16, 500)
					EntityKill(entity_id)
				else
					textprint = textprint .. "good"
					anim = "rolled_good"
					shoot_projectile(entity_id, "data/entities/items/pickup/chest_random_super.xml", pos_x - 16, pos_y - 16, 0, 0)
					shoot_projectile(entity_id, "data/entities/items/pickup/chest_random_super.xml", pos_x + 16, pos_y - 16, 0, 0)
					EntityKill(entity_id)
				end

				if #players > 0 then GamePrint(textprint) end
			end

			edit_component2(entity_id, "SpriteComponent", function(comp, vars)
				ComponentSetValue2(comp, "rect_animation", anim)
			end)
		end
	end

	ComponentSetValue2(rstorage, "value_int", status)
end
