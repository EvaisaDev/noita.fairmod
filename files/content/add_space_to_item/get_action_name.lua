dofile_once("data/scripts/gun/gun_actions.lua")

local names = {}
for i = 1, #actions do
	local action = actions[i]
	names[action.id] = action.name
end

return names
