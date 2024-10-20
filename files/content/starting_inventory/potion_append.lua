local ps = PotionStartingLib

ps.starterpotions = {
	{	probability = 32.5, 	"water"			},
	{	probability = 6.5, 		"mud"			},
	{	probability = 6.5, 		"water_swamp"	},
	{ 	probability = 6.5, 		"water_salt"	},
	{	probability = 6.5, 		"swamp"			},
	{	probability = 6.5, 		"snow"			},
	{	probability = 5, 		"blood"			},
}

ps.magicpotions = {
	{	"acid"							},
	{	"magic_liquid_polymorph"		},
	{	"magic_liquid_random_polymorph"	},
	{	"magic_liquid_berserk"			},
	{	"magic_liquid_charm"			},
	{	"magic_liquid_movement_faster"	},
}

ps.failpotions = {
	{	"slime"					},
	{	"gunpowder_unstable"	}
}

ps.functions = {
	function()
		if Random(1, 5) < 4 then
			local materials = nil
			if (Random(0, 1) == 1) then
				materials = CellFactory_GetAllLiquids(false)
			else
				materials = CellFactory_GetAllSands(false)
			end
		
			return random_from_array(materials)
		end
	end
}