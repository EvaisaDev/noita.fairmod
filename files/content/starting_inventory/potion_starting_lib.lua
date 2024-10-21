---@diagnostic disable: undefined-global
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/items/init_potion.lua")







--dont do stuff here dinguses and dingi, go to "content/starting_inventory/potion_append.lua"- which overwrites the default values here without the unnecessary clutter











--PotionStartingLib global table
PotionStartingLib = {}
local ps = PotionStartingLib --rename it here so it doesnt look ugly for the rest of the script

---Default potion material
local potion_material = "water"

---Current UTC time
ps.UTC = {}
ps.UTC.year, ps.UTC.month, ps.UTC.day, ps.UTC.hour, ps.UTC.minute, ps.UTC.second = GameGetDateAndTimeUTC()

---Current Local time (includes jussi and mammi bools)
ps.LOCAL = {}
ps.LOCAL.year, ps.LOCAL.month, ps.LOCAL.day, ps.LOCAL.hour, ps.LOCAL.minute, ps.LOCAL.second, ps.LOCAL.jussi, ps.LOCAL.mammi =
	GameGetDateAndTimeLocal()
--SetRandomSeed(ps.UTC.hour, ps.LOCAL.second)

SetRandomSeed(ps.UTC.second * ps.UTC.minute, ps.UTC.second * ps.UTC.hour)

---This function combines tables so you can easily merge your custom tables into the vanilla ones
function ps.CombineTables(base, addition)
	for i = 1, #addition do
		base[#base + 1] = addition[i]
	end
	return base
end

---Function that compares two tables to see if they are identical. Can be used to easily check between current date and desired date using tables. By Nahtan
function ps.CompareTables(a, b)
	if type(a) ~= type(b) then return false end
	if type(a) == "table" then
		for k, v in pairs(a) do
			if not ps.CompareTables(v, b[k]) then return false end
		end
		return true
	end
	return a == b
end --awesomium function grabbed from nathan (i was incompetent so he made the function for me)

---This function just corrects the tables that lack probability fields. Probability will default to 10 for all material tables
function ps.CorrectTables()
	for index, value in ipairs({ ps.starterpotions, ps.magicpotions, ps.failpotions }) do
		for k, v in ipairs(value) do
			if v.probability == nil then
				v.probability = 10 --[[print(v[1] .. " corrected.")]]
			end
		end
	end
end

---starter potions, 70% chance to pull from this table
ps.starterpotions = {
	{ probability = 32.5, "water" },
	{ probability = 6.5, "mud" },
	{ probability = 6.5, "water_swamp" },
	{ probability = 6.5, "water_salt" },
	{ probability = 6.5, "swamp" },
	{ probability = 6.5, "snow" },
	{ probability = 5, "blood" },
}

---magic potions, 29% chance to pull from this table
ps.magicpotions = {
	{ "acid" },
	{ "magic_liquid_polymorph" },
	{ "magic_liquid_random_polymorph" },
	{ "magic_liquid_berserk" },
	{ "magic_liquid_charm" },
	{ "magic_liquid_movement_faster" },
}

-- 1/10,000,100 technically, lmao.
ps.one_in_millions = { -- "key" must be from 1 to 100000
	{ key = 666, "urine" },
	{ key = 79, "gold" },
}

---Material outcomes if the "one-in-a-million" doesnt hit anything
ps.failpotions = {
	{ "t_omega_slicing_liquid" },
}

---Table of custom functions potion_a_materials runs through before returning the chosen material
---@type fun(outcome: string, r_value: number, r_value2: number, data: table)[]
ps.functions = {
	function()
		if
			ps.CompareTables({ ps.LOCAL.month, ps.LOCAL.day }, { 5, 1 })
			or ps.CompareTables({ ps.LOCAL.month, ps.LOCAL.day }, { 4, 30 }) and (Random(0, 100) <= 20)
		then
			return "sima"
		end
	end,
}

---Table of custom functions init runs through after potion_a_materials returns the chosen material
---@type fun(potion_material: string, data: table)[]
local functions2 = {}

---Function that chooses the potion material
---@diagnostic disable
function ps.potion_a_materials(outcome, r_value, r_value2, data) --Variables are available as inputs in case you want to run with forced RNG. data lets you pass extra data if you want
	outcome = outcome or potion_material
	r_value = r_value or Random(1, 100)
	r_value2 = r_value2 or Random(0, 100000)
	data = data or {}

	local rnd = random_create(r_value, r_value2)
	if r_value <= 70 then --70% chance for staterpotions
		outcome = pick_random_from_table_weighted(rnd, ps.starterpotions)[1]
	elseif r_value <= 99 then --29% chance for magicpotions
		r_value = Random(0, 100)
		outcome = pick_random_from_table_weighted(rnd, ps.magicpotions)[1]
	else --1% chance to try for the one_in_millions
		outcome = pick_random_from_table_weighted(rnd, ps.failpotions)[1]
		for k, v in pairs(ps.one_in_millions) do
			if r_value2 == v.key then outcome = v[1] end --loop over one_in_millions
		end
	end

	if ps.functions ~= nil then --in case someone empties the function to skip this step
		for index, value in pairs(ps.functions) do
			outcome = value(outcome, r_value, r_value2, data) or outcome
		end
	end

	return tostring(outcome)
end

---@diagnostic disable
function init(entity_id) --mostly vanilla function
	local x, y = EntityGetTransform(entity_id)
	ps.CorrectTables() --add default probabilities

	--ps.TEST(100000) --1 billion took about 45 minutes for me to render so 100k-10mil should be good enough for regular tests (probs still super excessive tbh lmao)
	--default value of 10000000 (ten million) takes approx 40 seconds for me, so it should be a good testing value (decrease to like, 100k or 1mil for faster testing ig, 100k should be basically instant)

	local n_of_deaths = tonumber(StatsGlobalGetValue("death_count"))
	if n_of_deaths >= 1 then
		potion_material = ps.potion_a_materials() or potion_material --if potion_a_materials returns nil or smth, default to potion_material
	end

	if functions2 ~= nil then
		for index, value in pairs(functions2) do
			potion_material = value(potion_material) or potion_material
		end
	end

	init_potion(entity_id, potion_material)
end

--Handy script for mass-generating potion outcomes and displaying them neatly in the console
function ps.TEST(num)
	local _table = {}
	_table["TOTAL"] = num --add total display

	for i = 1, num do --this is the most intensive part of the function at high values, so i return the current% to show current progress through running the test
		if i % (num / 100) == 0 then print(i / (num / 100) .. "%") end --prints current percentage when it can be displayed without decimals
		local result = ps.potion_a_materials() --simulate potion start
		_table[result] = (_table[result] or 0) + 1 --add string to table, give it +1 every time its returned
	end
	local t = {}
	for k, v in pairs(_table) do
		table.insert(t, { key = k, value = v }) --sort function grabbed from Ribbit and Horscht after very painstakingly futile attempts to explain this to me
	end
	table.sort(t, function(a, b)
		return a.value > b.value
	end)

	--wretched code, it does its job well... enough.
	local longest_name = 0
	local longest_amount = 0
	local longest_percent = 0
	for i, j in ipairs(t) do
		local n = string.len(tostring(j.key))
		if longest_name < n then longest_name = n end

		local a = string.len(tostring(j.value))
		if longest_amount < a then longest_amount = a end

		local p = math.min(string.len(tostring(({ math.modf(j.value / (num / 100)) })[2])) - 2, 30) --grabs the decimal length of the percentage minus 2 for the 0 and decimal point with maximum or 30
		if longest_percent < p then longest_percent = p end
	end

	local function add_gap(variable, size, before)
		if before then
			for l = 0, size - string.len(variable) do
				variable = " " .. variable
			end
		else
			for l = 0, size - string.len(variable) do
				variable = variable .. " "
			end
		end
		--print(string.format("[%s]", variable))
		return variable
	end

	for i, j in ipairs(t) do --print table
		local material_name = j.key
		local material_amount = j.value .. ","
		local material_percent = string.format(("%.Xf"):gsub("X", tostring(longest_percent)), j.value / (num / 100))
			.. "%"
		local material_percent_rounded = string.format("%.1f", math.floor(((j.value / (num / 100)) + 0.05) * 10) * 0.1)
			.. "%"

		material_name = add_gap(material_name, longest_name) --add gap after material name

		material_amount = add_gap(material_amount, longest_amount, true) --add gap before material amount
		material_amount = add_gap(material_amount, 15 - longest_amount) --add gap after material amount

		material_percent = add_gap(material_percent, longest_percent + 6, true) --add gap before material percentage
		material_percent = add_gap(material_percent, 20 - longest_percent) --add gap after material percentage

		material_percent_rounded = add_gap(material_percent_rounded, 13, true)

		print(
			material_name .. " = " .. material_amount .. material_percent .. material_percent_rounded .. "  " .. j.key
		) -- MATERIAL	= AMOUNT,   AMOUNT%				ROUNDED%  MATERIAL
	end
end
