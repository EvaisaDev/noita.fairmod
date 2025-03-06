local order_deck_old = order_deck
function order_deck(...)
	GlobalsSetValue("fair_risk", tostring(tonumber(GlobalsGetValue("fair_risk", "0"))+1))
	order_deck_old(...)
end