dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local CHANCE_TO_CRACK_PERCENT = 33
local FRAMES_TOO_FAST_TO_CRACK = 15
local NUM_TOTAL_CRACKS = 3

local function GetMaterialInventoryMainQuantity(entity_id)
	local inventory = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
	if inventory == nil then return end

	local counts = ComponentGetValue2(inventory, "count_per_material_type")
	if counts == nil then return end

	local main_material = GetMaterialInventoryMainMaterial(entity_id)
	return counts[main_material + 1] or 0
end

local rnd_glass_impacts = {
	"animals/crystal/damage/projectile",
	"animals/crystal/damage/physics_hit",
	"animals/crystal/damage/explosion",
	"animals/crystal/death"
}
local function play_crack_sound()
	local x, y, w, h = GameGetCameraBounds()
	local rnd = Random(1, 4)
	GamePlaySound("data/audio/Desktop/animals.bank", rnd_glass_impacts[rnd], x + w / 2, y + h / 2)
end

local function get_new_cracks(num, filename)
	if num == 0 then
		return table.concat{filename, ".fairmod_", Random(1, 7), ".png"}
	end

	local matched = {string.match(filename, "(.+)%.fairmod" .. string.rep("_(%d)", num))}
	local base_filename = matched[1]
	table.remove(matched, 1)

	local crack_exists = {}
	local cracks = {}
	for _, v in ipairs(matched) do
		v = tonumber(v)
		crack_exists[v] = true
		table.insert(cracks, v)
	end

	local choices = {}
	for i = 1,7 do
		if not crack_exists[i] then
			table.insert(choices, i)
		end
	end

	table.insert(cracks, choices[Random(1, #choices)])
	table.sort(cracks)

	return table.concat{base_filename, ".fairmod_", table.concat(cracks, "_"), ".png"}
end

local function crack_potion_ui(num, entity_id)
	GamePrint("Your potion cracked...")

	local item_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent")
	local potion_filename = ComponentGetValue2(item_comp, "ui_sprite")

	local filename = get_new_cracks(num, potion_filename)
	ComponentSetValue2(item_comp, "ui_sprite", filename)

	play_crack_sound()
end

local function advance_cracking_stage(entity_id)
	local rnd = Randomf(1, 100)
	if rnd <= CHANCE_TO_CRACK_PERCENT then
		local stage_comp = get_variable_storage_component(entity_id, "fairmod_potion_cracked_stage")
		if stage_comp == nil then return end

		local stage = ComponentGetValue2(stage_comp, "value_int")
		ComponentSetValue2(stage_comp, "value_int", stage + 1)

		if stage < NUM_TOTAL_CRACKS then
			crack_potion_ui(stage, entity_id)
		elseif stage >= NUM_TOTAL_CRACKS then
			GamePrint("Your potion shattered!")

			local player_entity = GetPlayers()[1]
			EntityDropItem(player_entity, entity_id)
			local x, y = EntityGetTransform(entity_id)
			EntityInflictDamage(entity_id, 100, "DAMAGE_PHYSICS_BODY_DAMAGED", "", "NORMAL", 0, 0)

			-- spawn more glass just to make it clear
			EntityLoad("data/entities/props/physics_glass_shard_01.xml", x - 1, y - 1)
			EntityLoad("data/entities/props/physics_glass_shard_02.xml", x - 1, y + 1)
			EntityLoad("data/entities/props/physics_glass_shard_03.xml", x + 1, y - 1)
			EntityLoad("data/entities/props/physics_glass_shard_04.xml", x + 1, y + 1)
		end
	end
end

--------------------------------------------------------------------------------------------------------------

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x, y + GameGetFrameNum())

-- Add crackable tag if this is an og potion, otherwise remove the component
if not EntityHasTag(entity_id, "crackable") then
	local item_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent")
	if item_comp == nil then
		EntityRemoveComponent(entity_id, GetUpdatedComponentID())
		return
	end

	local potion_filename = ComponentGetValue2(item_comp, "ui_sprite")
	if potion_filename == "data/ui_gfx/items/potion.png" then
		EntityAddTag(entity_id, "crackable")
	else
		EntityRemoveComponent(entity_id, GetUpdatedComponentID())
	end
	return
end

-- Compare material quantities, in case we've emptied the flask
local last_known_comp = get_variable_storage_component(entity_id, "fairmod_last_material_amount")
if last_known_comp == nil then return end

local last_amount = ComponentGetValue2(last_known_comp, "value_int")
local current_amount = GetMaterialInventoryMainQuantity(entity_id)
ComponentSetValue2(last_known_comp, "value_int", current_amount)

if current_amount == 0 and last_amount > 10 then
	advance_cracking_stage(entity_id)
	return
end


-- ALSO CHECK last_frame_drank
-- Compare usage times, in case we are consuming liquid quickly
local last_drank_comp = get_variable_storage_component(entity_id, "fairmod_last_last_frame_drank")
if last_drank_comp == nil then return end

local last_drank = ComponentGetValue2(last_drank_comp, "value_int")

local inventory = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
if inventory == nil then return end

local current_drank = ComponentGetValue2(inventory, "last_frame_drank")
ComponentSetValue2(last_drank_comp, "value_int", current_drank)

if current_drank > last_drank and current_drank - last_drank < FRAMES_TOO_FAST_TO_CRACK then
	advance_cracking_stage(entity_id)
	return
end
