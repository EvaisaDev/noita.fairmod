
local hm_banned_tags = {
	["[box2d]"] = true,
	["[catastrophic]"] = true,
	["[NO_FUNGAL_SHIFT]"] = true,
	["[acid]"] = true,
	["[evaporable]"] = true,
	["[evaporable_fast]"] = true,
	["[fire_strong]"] = true,
	["[materium_activate]"] = true,
}

local hm_banned_materials = {
	-- Midas
	midas_precursor = true,
	midas = true,
	-- Materials that vanish (lifetime or interact with air)
	magic_liquid = true,
	just_death = true,
	material_rainbow = true,
	magic_liquid_hp_regeneration_unstable = true,
	cloud_radioactive = true,
	cloud_blood = true,
	cloud_slime = true,
	creepy_liquid = true,
	rat_powder = true,
	fungus_powder = true,
	blood_cold = true,
	rocket_particles = true,
}

-- In addition to the above, the inside of the HM can't have these
local inner_hm_banned_materials = {
	cement = true,
	void_liquid = true,
	poison = true,	-- evaporates slowly

	-- Boring
	water = true,
	water_ice = true,
	water_temp = true,
	mimic_liquid = true,
}

function HMMaterialsFilter(mats, inside_hm)
	for i = #mats, 1, -1 do
		local mat = mats[i]

		if hm_banned_materials[mat] then
			table.remove(mats, i)
			goto continue
		end

		if inside_hm and inner_hm_banned_materials[mat] then
			table.remove(mats, i)
			goto continue
		end

		if mat:find("fading") or mat:find("molten") then
			table.remove(mats, i)
			goto continue
		end

		local tags = CellFactory_GetTags(CellFactory_GetType(mat)) or {}
		for _, tag in ipairs(tags) do
			if hm_banned_tags[tag] then
				table.remove(mats, i)
				goto continue
			end
		end
		::continue::
	end

	return mats
end
