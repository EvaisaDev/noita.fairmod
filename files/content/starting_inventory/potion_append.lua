function potion_a_materials()
	SetRandomSeed(1, 1)
	local materials = nil
	if Random(0, 100) <= 50 then
		materials = CellFactory_GetAllLiquids(false)
	else
		materials = CellFactory_GetAllSands(false)
	end

	return random_from_array(materials)
end
