local he = {
	offset_x = 31,
	offset_y = 13,
}

function he:update()
	local cx, cy, cw, ch = GameGetCameraBounds()
	SetRandomSeed(cx + GameGetFrameNum(), cy)
	if Random(1, 100) > 99 then
		local x = Random(1, 2) == 1 and cx + self.offset_x or cx + cw - self.offset_x
		local y = Random(1, 2) == 1 and cy + self.offset_y or cy + ch - self.offset_y
		EntityLoad("mods/noita.fairmod/files/content/big_brother/eye.xml", x + Randomf(-10, 10), y + Randomf(-5, 5))
	end
end

return he
