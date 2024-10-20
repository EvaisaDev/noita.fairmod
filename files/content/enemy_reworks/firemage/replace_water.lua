local file = "data/entities/animals/firemage.xml"

local content = ModTextFileGetContent(file)

content = content:gsub(
	'materials_how_much_damage=".-"',
	'materials_how_much_damage="0.004,-0.0005,0.001,0.0008,0.0007,-0.0005,-0.0005,-0.0005,-0.0005,-0.0005,-0.0005"'
)
content = content:gsub('wet_status_effect_damage=".-"', 'wet_status_effect_damage="-0.3"')

ModTextFileSetContent(file, content)
