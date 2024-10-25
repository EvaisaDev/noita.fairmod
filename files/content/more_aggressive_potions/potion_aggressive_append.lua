local pa = PotionAggressiveLib




pa.customfunctions = {
	function (potion)
		if Random(1, 100) == 100 then --1% chance for random material
			local liquids = MaterialsFilter(CellFactory_GetAllLiquids() or {})
			local sands = MaterialsFilter(CellFactory_GetAllSands() or {})
			local solids = MaterialsFilter(CellFactory_GetAllSolids() or {})
			local rand = Random(1, 3)
			if rand == 1 then
				local material = liquids[Random(1, #liquids)]
				return { material = material }
			elseif rand == 2 then
				local material = sands[Random(1, #sands)]
				return { material = material }
			else
				local material = solids[Random(1, #solids)]
				return { material = material }
			end
		end

		local r = Random(1, 20)
		if r > 19 then --5% chance for triple potion amount
			print("yayyyy")
			potion.amount = potion.amount * 3
		elseif r > 16 then --15% chance for double
			print("nayyyy")
			potion.amount = potion.amount * 2
		end
	end
}


pa.default_amount = 1000 --in case you wanted to change this

pa.potions = 
{
	{
		material="acid", --you probably shouldnt leave name blank, but it will default to "air" if you do
        probability=.2, --default probability is 10
        amount=100000, --reference to the funny 10000% acid potion mod
		cost=800, --default cost 200
		func = function (data) --function has no default, entirely optional
			local itemcomp = EntityGetComponent(data.entity_id, "ItemComponent") --function that adds funni names/descs to the acid potion
			if itemcomp == nil then return end
			ComponentSetValue2(itemcomp[1], "item_name", "$100000_percent_acid")
			ComponentSetValue2(itemcomp[1], "always_use_item_name_in_ui", true)
			ComponentSetValue2(itemcomp[1], "ui_description", GameTextGet("$100000_percent_acid_desc", "$bee_movie_script")) --low chance to just make it the entire bee movie script lmao
			ComponentSetValue2(itemcomp[1], "custom_pickup_string", GameTextGet("$100000_percent_acid_picked_up", "$100000_percent_acid"))
		end --just an example of the sort of thing you can do
	},
	{
		material="lava",
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
	},
	{
		material="cc_deceleratium",
		probability = 5,
	},
	{
		material="cc_heftium",
		probability = 5,
	},
	{
		material="cc_stillium",
		probability = 2,
	},
	{
		material="t_giga_slicing_liquid",
		probability = 4,
		amount = 500,
	},
	{
		material="cc_grease",
		probability = 20,
		amount = 1000,
	},
}