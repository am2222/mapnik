find_library(CAIRO_LIB_DEBUG cairod)
find_library(CAIRO_LIB_RELEASE cairo)
find_library(CAIRO_GOBJECT_LIB_DEBUG cairo-gobjectd)
find_library(CAIRO_GOBJECT_LIB_RELEASE cairo-gobject)

find_path(CAIRO_INCLUDE_DIR cairo/cairo.h)

find_library(SQLITE3_LIBRARY sqlite3)
find_library(ICUU_LIB icuuc.lib)
find_library(ICUD_LIB icuud.lib)

find_library(HARFBUZZ_LIB harfbuzz.lib)
