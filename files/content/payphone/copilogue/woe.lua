---@diagnostic disable-next-line: lowercase-global
function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local faction = GlobalsGetValue("hiisi_faction", "NONE")
	if faction == "NONE" then
		local test = EntityLoad("data/entities/animals/scavenger_smg.xml")
		local test_genome = EntityGetFirstComponentIncludingDisabled(test, "GenomeDataComponent") --[[@cast test_genome number]]
		local result = tostring(ComponentGetValue2( test_genome, "herd_id" ))
		GlobalsSetValue("hiisi_faction", result)
		faction = result
	end
	local genomedc = EntityGetFirstComponentIncludingDisabled(GetUpdatedEntityID(), "GenomeDataComponent") --[[@cast genomedc number]]
	if ComponentGetValue2( genomedc, "herd_id" ) ~= tonumber(GlobalsGetValue("hiisi_faction", "16")) then return end

	local spcs = EntityGetComponent(projectile_thats_responsible, "SpriteComponent") or {}
	local win = false
	for i=1, #spcs do
		local sprite = ComponentGetValue2(spcs[i], "image_file")
		if sprite == "mods/noita.fairmod/files/content/payphone/copilogue/mallninjaknife_proj.png" then
			win = true
			EntityInflictDamage(GetUpdatedEntityID(), 1000000, "DAMAGE_PHYSICS_BODY_DAMAGED", "Copi's Decree", "DISINTEGRATED", 0, 0, entity_thats_responsible)
			GlobalsSetValue("copi_winnerness", tostring(tonumber(GlobalsGetValue("copi_winnerness", "0") or "0")+1))
			GamePrint("Well done...")
			break
		end
	end
end