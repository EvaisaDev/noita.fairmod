-- Script to catch events on the player for achievements

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if EntityHasTag(projectile_thats_responsible, "snowball") then GameAddFlagRun("fairmod_snowball_hit") end
end
