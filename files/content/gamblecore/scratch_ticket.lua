-- scratchoff system

local price_values = {
	{
		price = 10,
		weight = 100,
	},
	{
		price = 25,
		weight = 100,
	},
	{
		price = 50,
		weight = 80,
	},
	{
		price = 100,
		weight = 50,
	},
	{
		price = 250,
		weight = 20,
	},
	{
		price = 500,
		weight = 10,
	},
	{
		price = 1000,
		weight = 5,
	},
	{
		price = 2500,
		weight = 2,
	},
	{
		price = 5000,
		weight = 1,
	},
	{
		price = 10000,
		weight = 1,
	},
}

local function GetRandomPrice()
	local total_weight = 0
	for _,v in ipairs(price_values) do
		total_weight = total_weight + v.weight
	end

	local rnd = Random(1, total_weight)
	local current_weight = 0
	for _,v in ipairs(price_values) do
		current_weight = current_weight + v.weight
		if rnd <= current_weight then
			return v.price
		end
	end

	return 0
end

local number_range = {1, 50}

local scratch_ticket = {
	new = function()
		local self = {
			winning_numbers = {},
			scratch_numbers = {},
			gui = GuiCreate(),
		}

		-- generate 5 winning numbers that are unique
		local numbers_picked = {}
		for i = 1, 5 do
			local number = Random(number_range[1], number_range[2])
			while numbers_picked[number] do
				number = Random(number_range[1], number_range[2])
			end
			numbers_picked[number] = true
			table.insert(self.winning_numbers, number)
		end

		-- generate 20 scratch numbers that are unique
		numbers_picked = {}
		for i = 1, 20 do
			local number = Random(number_range[1], number_range[2])
			while numbers_picked[number] do
				number = Random(number_range[1], number_range[2])
			end
			numbers_picked[number] = true
			table.insert(self.scratch_numbers, { number = number, scratched = false, prize = GetRandomPrice() })
		end
		
		self.draw = function(self)
			GuiStartFrame(self.gui)

			-- i forgot this would require effort :(
		end
		
	end
}
