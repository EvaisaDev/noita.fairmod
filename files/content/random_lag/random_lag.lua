local gluttony = {
	OnWorldPreUpdate = function ()
		if math.random(1,(GameGetFrameNum()+1000)%2000) == 1 then
			local t = GameGetRealWorldTimeSinceStarted()
			local quit = false
			while not quit do
				if GameGetRealWorldTimeSinceStarted() - t > math.random()*2.5+1 then
					quit = true
				else
					local shit = "CONCATS " .. "ARE " .. "FUCKING " .. "SLOW."
					GlobalsSetValue("fucking_lag", shit)
				end
			end
		end
	end
}

return gluttony