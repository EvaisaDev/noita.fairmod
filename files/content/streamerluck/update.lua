dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")


streamerluck_frames = streamerluck_frames or 0

streamerluck_frames = streamerluck_frames + 1

streaming_was_connected = streaming_was_connected or false

if(streamerluck_frames > 100 and StreamingGetIsConnected() and not streaming_was_connected)then
	streaming_was_connected = true

	GamePrintImportant("Streamer detected!", "Preparing streamer luck...")
	GamePrint("Streamer detected! Preparing streamer luck...")

	local players = GetPlayers()

	for i, v in ipairs(players) do
		local x, y = EntityGetTransform(v)
		SetRandomSeed(x, y)
		for _ = 1, 50 do

			local range = 100
			local angle = Random(0, 360)

			local target_x = x + math.cos(math.rad(angle)) * range
			local target_y = y - math.sin(math.rad(angle)) * range
			
			EntityLoad("data/entities/items/pickup/goldnugget_50.xml", target_x, target_y)
		end
	end
end