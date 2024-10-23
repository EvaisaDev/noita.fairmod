--This is a thing im trying out, location of this script is subject to change!!

dofile_once("data/scripts/lib/utilities.lua")

PotionAggressiveLib = {}

local pa = PotionAggressiveLib






pa.potions = 
{
	{
		material="lava",
		cost=300,
	},
	{
		material="water",
		cost=200,
	},
	{
		material="blood",
		cost=200,
	},
	{
		material="alcohol",
		cost=200,
	},
	{
		material="oil",
		cost=200,
	},
	{
		material="slime",
		cost=200,
	},
	{
		material="acid",
		cost=400,
	},
	{
		material="radioactive_liquid",
		cost=300,
	},
	{
		material="gunpowder_unstable",
		cost=400,
	},
	{
		material="liquid_fire",
		cost=400,
	},
	{
		material="magic_liquid_teleportation",
		cost=500,
	},
	{
		material="magic_liquid_berserk",
		cost=500,
	},
	{
		material="magic_liquid_charm",
		cost=800,
	},
	{
		material="blood_cold",
		cost=400,
	},
}

pa.customfunctions = {}

function init( entity_id )

	for index, v in pairs(pa.potions) do --default values
        v.material = v.material or "air"
        v.probability = v.probability or 10
        v.amount = v.amount or 1000
        v.cost = v.cost or 200 --cost isnt used for anything yet, but who knows, someone might fix that some day
	end

	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x + GameGetFrameNum(), y )
	
    
	local potion = pick_random_from_table_weighted(random_create(Randomf(), y), pa.potions )
    if potion == nil then print("*loud screeching noises from potion aggressive lib*") return end
    if potion.func then potion.func({entity_id = entity_id, x = x, y = y}) end
    
    for index, value in ipairs(pa.customfunctions) do
        value(potion, entity_id)
    end

    print(string.format("Aggressive Potion at [%s, %s] is material [%s]", x, y, potion.material))
	AddMaterialInventoryMaterial( entity_id, potion.material, potion.amount )
end