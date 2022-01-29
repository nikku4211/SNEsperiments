# Name
name		:= hewwohr
debug		:= 1

# Derived data files
derived_files	:= Data/3HCStairsDisplay.spc Data/hewwohr.png.palette Data/hewwohr.png.tiles Data/hewwohr.png.map

Data/hewwohr.png.palette: palette_flags = -v --tile-width 16 --tile-height 16
Data/hewwohr.png.tiles: tiles_flags = -v --tile-width 16 --tile-height 16 --out-image Data/hewwohr_tiles.png
Data/hewwohr.png.map: map_flags = -v --tile-width 16 --tile-height 16

# Include libSFX.make
libsfx_dir	:= ../libSFX
include $(libsfx_dir)/libSFX.make
