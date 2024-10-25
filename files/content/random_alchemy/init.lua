local randomizer = {
	debug = false,
}

local reactions = dofile_once("mods/noita.fairmod/files/content/random_alchemy/reaction_list.lua") --- @type random_alchemy[]
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local random_output = dofile_once("mods/noita.fairmod/files/content/random_alchemy/random_output_list.lua") --- @type string[]
local random_input = dofile_once("mods/noita.fairmod/files/content/random_alchemy/random_input_list.lua") --- @type string[]

local random_reactions_to_add = math.ceil(#reactions / 8)

local function generate_unique_random_numbers(n, min, max)
	local numbers, result = {}, {}
	local fail_over = 0
	while #result < n do
		local rand = Random(min, max)
		if not numbers[rand] then
			numbers[rand] = true
			result[#result + 1] = rand
		end
		fail_over = fail_over + 1
		if fail_over > 1000 then break end
	end
	return result
end

local random_output_count = #random_output
local random_input_count = #random_input

local function set_inputs(reaction_data)
	reaction_data.input_cell1 = reaction_data.input_cell1 or random_input[Random(1, random_input_count)]
	if not reaction_data.input_cell2 then
		local index = Random(1, random_input_count)
		for _ = 1, random_input_count do
			reaction_data.input_cell2 = random_input[index]
			if reaction_data.input_cell1 ~= reaction_data.input_cell2 then break end
			index = index % random_input_count + 1
		end
	end
end

local function add_reaction(xml, number)
	local reaction_data = reactions[number]
	reaction_data.probability = reaction_data.probability or tostring(Random(1, 80))
	set_inputs(reaction_data)
	reaction_data.output_cell1 = reaction_data.output_cell1 or random_output[Random(1, random_output_count)]
	reaction_data.output_cell2 = reaction_data.output_cell2 or random_output[Random(1, random_output_count)]
	local reaction = nxml.new_element("Reaction", reaction_data)
	xml:add_child(reaction)
	if randomizer.debug then
		print("New Reaction!")
		local keys = {}
		for k in pairs(reaction_data) do
			keys[#keys + 1] = k
		end
		table.sort(keys)
		for i = 1, #keys do
			local key = keys[i]
			print(key .. ": " .. reaction_data[key])
		end
		print("")
	end
end

function randomizer:create()
	SetRandomSeed(GameGetFrameNum(), GameGetRealWorldTimeSinceStarted())
	local selected = generate_unique_random_numbers(random_reactions_to_add, 1, #reactions)

	for xml in nxml.edit_file("data/materials.xml") do
		for i = 1, #selected do
			add_reaction(xml, selected[i])
		end
	end
end

randomizer:create()
