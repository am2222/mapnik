cmake_minimum_required(VERSION 3.13.4)
project(mapnik)
set(CMAKE_CXX_STANDARD 14)


option(WITH_GRID "Use the grid renderer" OFF)


if(MSVC)
  # Force to always compile with W4
  if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W1" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W1")
  endif()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  /wd\"4068\" /wd\"4661\" /wd\"4503\" ")
endif()



find_package(Boost REQUIRED
             COMPONENTS filesystem system regex program_options)              
             
include(dependencies.cmake)

find_package(FreeType REQUIRED)
find_package(GDAL REQUIRED)
find_package(protobuf REQUIRED)
#find_package(HarfBuzz REQUIRED)
#find_package(icu REQUIRED COMPONENTS uc)
find_package(PNG REQUIRED)
find_package(jpeg REQUIRED)
find_package(PROJ4 REQUIRED)
find_package(PostgreSQL REQUIRED)
find_package(tiff REQUIRED)
# find_package(sqlite3 REQUIRED)
find_package(WebP REQUIRED)
find_package(WebP REQUIRED)
find_package(LibXml2 REQUIRED)
find_package(ZLIB REQUIRED)


# AGG

set(AGG_SOURCES
    deps/agg/src/agg_arc.cpp
    deps/agg/src/agg_arrowhead.cpp
    deps/agg/src/agg_bezier_arc.cpp
    deps/agg/src/agg_bspline.cpp
    deps/agg/src/agg_curves.cpp
    deps/agg/src/agg_embedded_raster_fonts.cpp
    deps/agg/src/agg_gsv_text.cpp
    deps/agg/src/agg_image_filters.cpp
    deps/agg/src/agg_line_aa_basics.cpp
    deps/agg/src/agg_line_profile_aa.cpp
    deps/agg/src/agg_pixfmt_rgba.cpp
    deps/agg/src/agg_rounded_rect.cpp
    deps/agg/src/agg_sqrt_tables.cpp
    deps/agg/src/agg_trans_affine.cpp
    deps/agg/src/agg_trans_double_path.cpp
    deps/agg/src/agg_trans_single_path.cpp
    deps/agg/src/agg_trans_warp_magnifier.cpp
    deps/agg/src/agg_vcgen_bspline.cpp
    deps/agg/src/agg_vcgen_contour.cpp
    deps/agg/src/agg_vcgen_dash.cpp
    deps/agg/src/agg_vcgen_markers_term.cpp
    deps/agg/src/agg_vcgen_stroke.cpp
    deps/agg/src/agg_vpgen_clip_polygon.cpp
    deps/agg/src/agg_vpgen_clip_polyline.cpp
    deps/agg/src/agg_vpgen_segmentator.cpp )    


# placeholder for things which just don't work
include(files.cmake)

set(MAPNIK_SOURCES ${MAPNIK_SOURCES}
    src/agg/agg_renderer.cpp
    src/agg/process_building_symbolizer.cpp
    src/agg/process_debug_symbolizer.cpp
    src/agg/process_dot_symbolizer.cpp
    src/agg/process_group_symbolizer.cpp
    src/agg/process_line_pattern_symbolizer.cpp
    src/agg/process_line_symbolizer.cpp
    src/agg/process_markers_symbolizer.cpp
    src/agg/process_point_symbolizer.cpp
    src/agg/process_polygon_pattern_symbolizer.cpp
    src/agg/process_polygon_symbolizer.cpp
    src/agg/process_raster_symbolizer.cpp
    src/agg/process_shield_symbolizer.cpp
    src/agg/process_text_symbolizer.cpp)

set(MAPNIK_SOURCES ${MAPNIK_SOURCES}
    src/cairo/process_markers_symbolizer.cpp
    src/cairo/process_group_symbolizer.cpp
    
    src/cairo/cairo_context.cpp
    src/cairo/cairo_render_vector.cpp
    src/cairo/cairo_renderer.cpp
    src/cairo/process_building_symbolizer.cpp
    src/cairo/process_debug_symbolizer.cpp
    src/cairo/process_line_pattern_symbolizer.cpp
    src/cairo/process_line_symbolizer.cpp
    src/cairo/process_point_symbolizer.cpp
    src/cairo/process_polygon_pattern_symbolizer.cpp
    src/cairo/process_polygon_symbolizer.cpp
    src/cairo/process_raster_symbolizer.cpp
    src/cairo/process_text_symbolizer.cpp)

if (WITH_GRID)
set(MAPNIK_SOURCES ${MAPNIK_SOURCES}
    src/grid/grid.cpp
    src/grid/grid_renderer.cpp
    src/grid/process_building_symbolizer.cpp
    src/grid/process_line_pattern_symbolizer.cpp
    src/grid/process_line_symbolizer.cpp
    src/grid/process_point_symbolizer.cpp
    src/grid/process_polygon_pattern_symbolizer.cpp
    src/grid/process_polygon_symbolizer.cpp
    src/grid/process_raster_symbolizer.cpp
    src/grid/process_shield_symbolizer.cpp
    src/grid/process_text_symbolizer.cpp)
set(MAPNIK_DEFS ${MAPNIK_DEFS} -DGRID_RENDERER)
ENDIF()
message(STATUS "Grid renderer: " ${WITH_GRID})
    
set(MAPNIK_SOURCES ${MAPNIK_SOURCES}
    src/svg/output/svg_output_grammars.cpp
    src/svg/output/svg_renderer.cpp
    src/svg/output/svg_generator.cpp
    src/svg/output/svg_output_attributes.cpp
    src/svg/output/process_symbolizers.cpp
    src/svg/output/process_line_symbolizer.cpp
    src/svg/output/process_polygon_symbolizer.cpp)
set(MAPNIK_DEFS ${MAPNIK_DEFS} -DSVG_RENDERER)

    
set(MAPNIK_SOURCES ${MAPNIK_SOURCES}
    src/jpeg_reader.cpp
    src/libxml2_loader.cpp
    src/png_reader.cpp
    src/tiff_reader.cpp
    src/webp_reader.cpp
    )
    
#set(MAPNIK_SOURCES ${MAPNIK_SOURCES} src/rapidxml_loader.cpp)

set(MAPNIK_DEFS ${MAPNIK_DEFS}
-DHAVE_CAIRO
-DHAVE_PNG
-DHAVE_JPEG
-DHAVE_TIFF
-DHAVE_WEBP
-DUSE_PROJ4
-DMAPNIK_USE_PROJ4

-DHAVE_LIBXML2

-DBOOST_REGEX_HAS_ICU)

set(mapnik_include_paths
    include
    deps
    deps/agg/include
    deps/mapbox/geometry/include
    deps/mapbox/polylabel/include
    deps/mapbox/variant/include)
    
set(thirdparty_include_paths
    ${Boost_INCLUDE_DIRS}
    ${CAIRO_INCLUDE_DIR}
    ${FREETYPE_INCLUDE_DIRS}
    ${ICU_INCLUDE_DIRS}
    ${PNG_INCLUDE_DIRS}
    ${JPEG_INCLUDE_DIR}
    ${PROJ4_INCLUDE_DIRS}
    ${TIFF_INCLUDE_DIRS}
    ${SQLITE3_INCLUDE_DIRS}
    ${WebP_INCLUDE_DIRS})

set(all_libraries
    ${Boost_LIBRARIES}
    $<$<CONFIG:Debug>:${CAIRO_LIB_DEBUG}> $<$<CONFIG:Release>:${CAIRO_LIB_RELEASE}>
    ${FREETYPE_LIBRARY}
    ${HARFBUZZ_LIB}
    ${ICUU_LIB}
    ${JPEG_LIBRARY}
    ${PNG_LIBRARY}
    ${PROJ4_LIBRARY_DIRS}/proj.lib # not .obj, you stupid module.
    ${SQLITE3_LIBRARY}
    ${TIFF_LIBRARIES}
    ${WebP_LIBRARY}
    ${LIBXML2_LIBRARIES}
    ${ZLIB_LIBRARIES}
    )
    
    
set(MAPNIK_DEFS ${MAPNIK_DEFS} -DMAPNIK_EXPORTS)

    
include_directories(${mapnik_include_paths}  ${thirdparty_include_paths})
    
add_library(mapnik SHARED ${MAPNIK_SOURCES} ${AGG_SOURCES})
target_compile_definitions(mapnik PRIVATE ${MAPNIK_DEFS})

target_include_directories(mapnik INTERFACE ${mapnik_include_paths}  ${thirdparty_include_paths})
target_link_libraries(mapnik PUBLIC ${all_libraries})

add_subdirectory(src/json EXCLUDE_FROM_ALL)
add_subdirectory(src/wkt EXCLUDE_FROM_ALL)


add_subdirectory(plugins/input/csv)
add_subdirectory(plugins/input/gdal)
#add_subdirectory(plugins/input/geobuf)
add_subdirectory(plugins/input/geojson)
add_subdirectory(plugins/input/ogr)
add_subdirectory(plugins/input/pgraster)
add_subdirectory(plugins/input/postgis)
add_subdirectory(plugins/input/raster)
add_subdirectory(plugins/input/shape)
add_subdirectory(plugins/input/sqlite)
add_subdirectory(plugins/input/topojson)


add_subdirectory(demo/c++)
#add_subdirectory(demo/viewer)
