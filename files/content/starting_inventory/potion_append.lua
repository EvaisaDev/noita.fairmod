local ps = PotionStartingLib

ps.starterpotions = {
	{ probability = 32.5, "cement" },
	{ probability = 13, "milk" },
	{ probability = 6.5, "diamond" },
	{ probability = 6.5, "endslime_static" },
	{ probability = 6.5, "beer" },
	{ probability = 6.5, "alcohol" },
	{ probability = 6.5, "oil" },
	{ probability = 6.5, "material_darkness" },
	{ probability = 5, "swamp" },
}

ps.magicpotions = { --nested in tables due to probability field. Default probability is 10
	{ "magic_liquid_polymorph" },
	{ "aa_unstable_pandorium" },
	{ "fairmod_chaotic_pandorium" },
	{ "fairmod_giga_slicing_liquid" },
	{ "t_omega_slicing_liquid" },
	{ "material_confusion" },
	{ "magic_liquid_weakness" },
	{ "fairmod_propanium", probability = 1 },
	{ "fairmod_tntinium", probability = 1 },
	{ "fairmod_minecartium", probability = 1 },
	{ "fairmod_hamisium", probability = 1 },
}

ps.failpotions = { --same deal here with the nested tables
	{ "magic_liquid" },
	{ "magic_liquid_worm_attractor" },
	{ "t_omega_slicing_liquid" },
} --fail list for if the one_in_millions fail

-- 1/10,000,100 technically, lmao.
ps.one_in_millions = { -- "key" must be from 1 to 100000
	{ key = 666, "urine" },
	{ key = 79, "gold" },
	{ key = 0, "midas" }, --lmao
}

ps.functions = {
	function()
		if
			ps.CompareTables({ ps.LOCAL.month, ps.LOCAL.day }, { 5, 1 })
			or ps.CompareTables({ ps.LOCAL.month, ps.LOCAL.day }, { 4, 30 }) and (Random(0, 100) <= 20)
			or ps.LOCAL.jussi and (Random(0, 100) <= 20)
		then
			return "just_death"
		end
	end,
	function()
		if Random(1, 5) < 4 then
			local materials = nil
			if Random(0, 1) == 1 then
				materials = CellFactory_GetAllLiquids(false)
			else
				materials = CellFactory_GetAllSands(false)
			end

			return random_from_array(materials)
		end
	end,
}
