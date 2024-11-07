dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")
local actions = {
	{
		id					= "BETA",
		name				= "$action_gamma",
		description			= "$actiondesc_gamma",
		sprite				= "mods/noita.fairmod/files/content/.greeks/beta.png",
		sprite_unidentified	= "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		spawn_requires_flag	= "card_unlocked_duplicate",
		type				= ACTION_TYPE_OTHER,
		recursive			= true,
		spawn_level			= "0,1,2,3,4,5,6", -- MANA_REDUCE
		spawn_probability	= "0.5,0.5,0.5,0.5,0.5,0.5,0.5", -- MANA_REDUCE
		price				= -10,
		mana				= 69,
		action				= function( recursion_level, iteration )
			c.fire_rate_wait = c.fire_rate_wait + 15

			local t = MergeTables(deck, hand)

			local data = t[GameGetFrameNum()%gun.deck_capacity]

			local rec = check_recursion( data, recursion_level )

			if ( data ~= nil ) and ( rec > -1 ) then
				data.action( rec )
			end
		end,
	}
}