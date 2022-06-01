# Name
name		:= gokudrip
debug		:= 1

#SPC700 projects
smp_overlays := SMP-Play

# Derived data files
#derived_files	:= Data/gokudrip.png.palette Data/gokudrip.png.tiles Data/gokudrip.png.map Data/memetext.png.palette Data/memetext.png.tiles Data/memetext.png.map SMP-Play/Data/gokudrip.brr 

#Data/memetext.png.palette: palette_flags = -v --colors 4
#Data/memetext.png.tiles: tiles_flags = -v -B 2
#Data/memetext.png.map: map_flags = -v -B 2

# Explicit cleanup
clean_files := SMP-Play-ZP.bin

# Include libSFX.make
libsfx_dir	:= ../../libSFX
include $(libsfx_dir)/libSFX.make
