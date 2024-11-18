set target=tree

set target_location=%CD%
cd C:\Program Files (x86)\Steam\steamapps\common\Noita
noita_dev.exe -splice_pixel_scene "%target_location%\%target%.png" -x 0 -y 0 -debug 1
xcopy "C:\Program Files (x86)\Steam\steamapps\common\Noita\data\biome_impl\spliced\%target%" "%target_location%\%target%" /D /y