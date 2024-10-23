local pa = PotionAggressiveLib

pa.potions = 
{
	{
		material="acid", --you probably shouldnt leave name blank, but it will default to "air"
        probability=.05, --default probability is 10
        amount=100000, --reference to the funny 10000% acid potion mod
		cost=800,
		func = function (data) --function that adds funni names/descs to the acid potion
			local itemcomp = EntityGetComponent(data.entity_id, "ItemComponent")
			if itemcomp == nil then return end
			ComponentSetValue2(itemcomp[1], "item_name", "$100000_percent_acid")
			ComponentSetValue2(itemcomp[1], "always_use_item_name_in_ui", true)
			ComponentSetValue2(itemcomp[1], "ui_description", "$100000_percent_acid_desc")
			ComponentSetValue2(itemcomp[1], "custom_pickup_string", GameTextGet("$100000_percent_acid_picked_up", "$100000_percent_acid"))
		end
	},
	{
		material="lava",
        probability=10,
        amount=1500,
		cost=300,
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
		amount=500, --decreased amount in case someone grabs one to open the eye room lmao
		cost=500,
	},
	{
		material="blood_cold",
		cost=400,
	},
}