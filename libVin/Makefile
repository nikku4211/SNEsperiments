# Name
name		:= LookASquirrel
debug := 1

# Derived data files
#derived_files	:= data/squirrelphototileset.png.palette 
#derived_files	:= data/squirrelphototileset.png.tiles 
#derived_files	:= data/squirrelphototileset.png.map
derived_files	:= data/sfbgf.png.palette
derived_files	+= data/sfbgf.png.tiles
derived_files	+= data/sfbgf.png.map

#data/squirrelphototileset.png.palette: palette_flags = -v --colors 256
#data/squirrelphototileset.png.tiles: tiles_flags =  --in-palette data/squirrelphototilesetcomb.png.palette -v -M snes -B 8
#data/squirrelphototileset.png.map: map_flags = -v -M snes -B 8
data/sfbgf.png.palette: palette_flags = -v --colors 4
data/sfbgf.png.tiles: tiles_flags = -v -B 2
data/sfbgf.png.map: map_flags = -v -M snes -B 2

# Include libSFX.make
libsfx_dir	:= ../../libSFX
include $(libsfx_dir)/libSFX.make
