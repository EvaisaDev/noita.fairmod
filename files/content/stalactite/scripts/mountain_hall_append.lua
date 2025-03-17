RegisterSpawnFunction(0xffa63ba9, "spawn_stalactite_1")
RegisterSpawnFunction(0xffbc42c0, "spawn_stalactite_2")
RegisterSpawnFunction(0xffce4ee8, "spawn_stalactite_3")
RegisterSpawnFunction(0xff9c24d0, "spawn_stalactite_4")
RegisterSpawnFunction(0xff794092, "spawn_stalactite_5")
RegisterSpawnFunction(0xff872eae, "spawn_stalactite_6")
RegisterSpawnFunction(0xffb24ddd, "spawn_stalactite_7")
RegisterSpawnFunction(0xffb332ea, "spawn_stalactite_8")
RegisterSpawnFunction(0xffa649cd, "spawn_stalactite_9")
RegisterSpawnFunction(0xff8e2ab8, "spawn_stalactite_10")
RegisterSpawnFunction(0xffac5cdd, "spawn_stalactite_11")
RegisterSpawnFunction(0xff9146bf, "spawn_stalactite_12")
RegisterSpawnFunction(0xff6c2895, "spawn_stalactite_13")
RegisterSpawnFunction(0xffddcaec, "spawn_jerma")

function spawn_stalactite_1(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_1.xml", x + 5, y)
end

function spawn_stalactite_2(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_2.xml", x + 7, y)
end

function spawn_stalactite_3(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_3.xml", x + 3, y)
end

function spawn_stalactite_4(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_4.xml", x + 3, y)
end

--[[
5: 6 - 14 (794092)
6: 5 - 20 (872eae)
7: 3 - 19 (b24ddd) 
8: 3 - 8 (b332ea)
9: 4 - 46 (a649cd)
10: 5 - 11 (8e2ab8)
11: 4 - 12 (ac5cdd)
12: 8 - 23 (9146bf)
13: 5 - 10 (6c2895)

]]

function spawn_stalactite_5(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_5.xml", x + 6, y)
end

function spawn_stalactite_6(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_6.xml", x + 5, y)
end

function spawn_stalactite_7(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_7.xml", x + 3, y)
end

function spawn_stalactite_8(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_8.xml", x + 3, y)
end

function spawn_stalactite_9(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_9.xml", x + 4, y)
end

function spawn_stalactite_10(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_10.xml", x + 5, y)
end

function spawn_stalactite_11(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_11.xml", x + 4, y)
end

function spawn_stalactite_12(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_12.xml", x + 8, y)
end

function spawn_stalactite_13(x, y)
	EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/triggers/stalactite_entrance_13.xml", x + 5, y)
end


function spawn_jerma(x, y)
	EntityLoad("mods/noita.fairmod/files/content/anti_dmca/jerma.xml", x, y)
end