local old_generate_shop_item = generate_shop_item

generate_shop_item = function( x, y, cheap_item, biomeid_, is_stealable )
	-- no more stealing you fuckers
	is_stealable = false
	
	return old_generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
end