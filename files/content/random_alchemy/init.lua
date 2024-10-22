local reactions = dofile_once("mods/noita.fairmod/files/content/random_alchemy/reaction_list.lua") --- @type random_alchemy[]
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml
local random_output = dofile_once("mods/noita.fairmod/files/content/random_alchemy/random_output_list.lua") --- @type string[]

local random_reactions_to_add = 5

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

SetRandomSeed(GameGetFrameNum(), GameGetRealWorldTimeSinceStarted())

local selected = generate_unique_random_numbers(random_reactions_to_add, 1, #reactions)
local random_output_count = #random_output

for xml in nxml.edit_file("data/materials.xml") do
	for i = 1, #selected do
		local selected_number = selected[i]
		local reaction_data = reactions[selected_number]
		reaction_data.probability = reaction_data.probability or "80"
		reaction_data.output_cell1 = reaction_data.output_cell1 or random_output[Random(1, random_output_count)]
		reaction_data.output_cell2 = reaction_data.output_cell2 or random_output[Random(1, random_output_count)]
		local reaction = nxml.new_element("Reaction", reaction_data)
		xml:add_child(reaction)
	end
end
