local module = {}
local secret_note_coords = {0, 0}
module.init = function()

	-- check if we have already generated the secret note coords
	local coords = GlobalsGetValue("fairmod.secret_coords", "")
	if coords ~= "" then
		local x, y = string.match(coords, "(.-),%s*(.+)")
		secret_note_coords = {tonumber(x), tonumber(y)}

		return
	end

	local width, height = BiomeMapGetSize()
	width = width * 512
	height = height * 512
	
	local x = Random(-(width * 2), (width * 2))
	local y = Random(-(height * 2), (height * 2))

	secret_note_coords = {x, y}

	GlobalsSetValue("fairmod.secret_coords", x .. ", " .. y)
end

module.update = function()
	if(not GameHasFlagRun("secret_text_spawned") and GameHasFlagRun("note_received"))then
		local players = EntityGetInRadiusWithTag(secret_note_coords[1], secret_note_coords[2], 400, "player_unit")
	
		if(players == nil or #players == 0)then
			return
		end

		GameAddFlagRun("secret_text_spawned")

		LoadBackgroundSprite("mods/noita.fairmod/files/content/secret/lazy.png", secret_note_coords[1], secret_note_coords[2], -100, false)
	end
end

return module