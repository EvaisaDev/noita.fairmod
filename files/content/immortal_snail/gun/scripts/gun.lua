local order_deck_old = order_deck
function order_deck(...)
	if not reflecting then
		GlobalsSetValue("fair_risk", tostring(tonumber(GlobalsGetValue("fair_risk", "0"))+1))
	end
	order_deck_old(...)
end