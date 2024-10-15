local entity_id = GetUpdatedEntityID()

if (GameHasFlagRun("kolmi_killed") and not EntityHasTag(entity_id, "ending_sampo_spot_underground")) then
	EntityAddTag(entity_id, "ending_sampo_spot_underground")
end