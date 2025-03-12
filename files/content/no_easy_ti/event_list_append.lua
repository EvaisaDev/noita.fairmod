-- Remove all good events
for i = #streaming_events, 1, -1 do
	if streaming_events[i].kind == STREAMING_EVENT_GOOD then
		table.remove(streaming_events, i)
	end
end
