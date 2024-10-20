local file = "data/entities/animals/fish.xml"

local content = ModTextFileGetContent(file)

content = content:gsub('materials_how_much_damage=".-"', 'materials_how_much_damage=""')
content = content:gsub('materials_that_damage=".-"', 'materials_that_damage=""')

ModTextFileSetContent(file, content)
