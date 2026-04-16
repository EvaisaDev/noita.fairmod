mask_list = {
	{
		name = "Vulnerable Mask",
		filepath = "mods/noita.fairmod/files/content/mask_box/mask_gfx/vulnerable.xml",
		weight = 1.0,
	},
	{
		name = "Hämis Mask",
		filepath = "mods/noita.fairmod/files/content/mask_box/mask_gfx/longleg.xml",
		weight = 1.0,
	},
	{
		name = "Golden Hämis Mask",
		filepath = "mods/noita.fairmod/files/content/mask_box/mask_gfx/longleg_gold.xml",
		weight = 0.1,
	},
	{
		name = "Bat Mask",
		filepath = "mods/noita.fairmod/files/content/mask_box/mask_gfx/bat.xml",
		weight = 1.0,
	},
	{
		name = "Suspicious Mask",
		filepath = "mods/noita.fairmod/files/content/mask_box/mask_gfx/sus.xml",
		weight = 0.1,
	},
	{
		name = "Steve Mask",
		filepath = "mods/noita.fairmod/files/content/mask_box/mask_gfx/steve.xml",
		weight = 1.0,
	},
}

function ChooseRandomMask(x, y)
	SetRandomSeed(GameGetFrameNum() + x + y, GameGetFrameNum() + y + x)
	local poolsize = 0
	for k = 1, #mask_list do
		poolsize = poolsize + mask_list[k].weight
	end

	local selection = Randomf(0, poolsize)

	for k = 1, #mask_list do
		selection = selection - mask_list[k].weight
		if selection <= 0 then
			GamePrint(table.concat({ "You have equipped the ", mask_list[k].name }))
			return mask_list[k].filepath
		end
	end
end
