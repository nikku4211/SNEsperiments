# Name
name		:= NSEVN
debug		:= 1

# Derived data files
#derived_files	:= data/NSEVNTestBG.png.palette data/NSEVNTestBG.png.tiles data/NSEVNTestBG.png.map data/font.png.palette data/font.png.tiles

#data/NSEVNTestBG.png.palette: palette_flags = -v --colors 256
#data/NSEVNTestBG.png.tiles: tiles_flags = -v -M snes -B 8
#data/NSEVNTestBG.png.map: map_flags = -v -M snes -B 8
data/font.png.palette: palette_flags = -v --colors 4
data/font.png.tiles: tiles_flags = -v -B 2 -D

# Include libSFX.make
libsfx_dir	:= ../../libSFXc/libSFX
include $(libsfx_dir)/libSFX.make
