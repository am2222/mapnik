cmake_minimum_required(VERSION 3.13.4)
project(mapnik)
set(CMAKE_CXX_STANDARD 14)
include(CMakeDependentOption)


option(MAPNIK_STATIC_LIB   "Build a static library" ON)

option(WITH_DEMO   "Build demo" ON)
option(WITH_VIEWER "Build viewer"  OFF)


option(WITH_INPUTS "Build input plugins" ON)

CMAKE_DEPENDENT_OPTION(WITH_INPUT_CSV       "Build the csv input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_GDAL      "Build the gdal input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_GEOBUF    "Build the geobuf input plugin" OFF "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_GEOJSON   "Build the geojson input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_OGR       "Build the ogr input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_PGRASTER  "Build the pgraster input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_POSTGIS   "Build the postgis input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_RASTER    "Build the raster input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_SHAPE     "Build the shape input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_SQLITE    "Build the sqlite input plugin" ON "WITH_INPUTS" ON)
CMAKE_DEPENDENT_OPTION(WITH_INPUT_TOPOJSON  "Build the topojson input plugin" ON "WITH_INPUTS" ON)

option(WITH_UTILS  "Build the utilities" ON )

option(WITH_GRID "Use the grid renderer" OFF)
option(WITH_CAIRO "Use cairo" ON)
option(WITH_PROJ4 "Use proj4" ON)

if(MSVC)
  # Force to always compile with W4
  if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W1" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W1")
  endif()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  /wd\"4068\" /wd\"4661\" /wd\"4503\" ")
  add_compile_options(/MP)
  add_compile_options(-bigobj) #added by @am2222
  add_compile_definitions(ACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1) #added by @am2222 for proj4 compile


endif()

find_package(Boost REQUIRED
             COMPONENTS filesystem system regex program_options)

find_package(FreeType REQUIRED)

find_library(HARFBUZZ_LIB harfbuzz.lib)
find_package(ICU REQUIRED COMPONENTS uc)

find_package(PNG     REQUIRED)
find_package(jpeg    REQUIRED)
find_package(tiff    REQUIRED)
find_package(WebP    REQUIRED)
find_package(LibXml2 REQUIRED)
find_package(ZLIB    REQUIRED)

set (MAPNIK_DEFS 
    -DHAVE_PNG
    -DHAVE_JPEG
    -DHAVE_TIFF
    -DHAVE_WEBP)

set(thirdparty_include_paths ${thirdparty_include_paths}
    ${JPEG_INCLUDE_DIR} ${WEBP_INCLUDE_DIRS} ${LIBXML2_INCLUDE_DIR})
    
set(thirdparty_libraries ${thirdparty_libraries}
    ${JPEG_LIBRARIES} ${WEBP_LIBRARIES} ${LIBXML2_LIBRARIES} ${HARFBUZZ_LIB})

# AGG

include(files.cmake)

if (WITH_CAIRO)
    find_library(CAIRO_LIB_DEBUG cairod)
    find_library(CAIRO_LIB_RELEASE cairo)
    find_library(CAIRO_GOBJECT_LIB_DEBUG cairo-gobjectd)
    find_library(CAIRO_GOBJECT_LIB_RELEASE cairo-gobject)
    find_path(CAIRO_INCLUDE_DIR cairo/cairo.h)

    set(thirdparty_include_paths ${thirdparty_include_paths} ${CAIRO_INCLUDE_DIR})
    set(thirdparty_libraries ${thirdparty_libraries} $<$<CONFIG:Debug>:${CAIRO_LIB_DEBUG}> $<$<CONFIG:Release>:${CAIRO_LIB_RELEASE}>)
    
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
        
    set(MAPNIK_DEFS ${MAPNIK_DEFS} -DHAVE_CAIRO)
endif()
message(STATUS "Cairo renderer " ${WITH_CAIRO})

if (WITH_PROJ4)
    find_package(PROJ4 REQUIRED)
    set(thirdparty_include_paths ${thirdparty_include_paths} ${PROJ4_INCLUDE_DIRS})
    set(thirdparty_libraries ${thirdparty_libraries} ${PROJ4_LIBRARIES})

    set(MAPNIK_DEFS ${MAPNIK_DEFS} -DMAPNIK_USE_PROJ4)
endif()

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

set(MAPNIK_DEFS ${MAPNIK_DEFS} -DHAVE_LIBXML2 -DBOOST_REGEX_HAS_ICU)

set(mapnik_include_paths
    include
    deps
    deps/agg/include
    deps/mapbox/geometry/include
    deps/mapbox/polylabel/include
    deps/mapbox/variant/include)
    

    
include_directories(${mapnik_include_paths}  ${thirdparty_include_paths})

if (MAPNIK_STATIC_LIB)
    message(STATUS "Building static library")
    add_library(mapnik STATIC ${MAPNIK_SOURCES} ${MAPNIK_AGG_SOURCES} ${AGG_SOURCES})
    target_compile_definitions(mapnik PUBLIC  -DMAPNIK_STATICLIB)
    set(MAPNIK_LIB_DEFINITION -DMAPNIK_STATICLIB)
else ()
    message(STATUS "Building shared library")
    add_library(mapnik SHARED ${MAPNIK_SOURCES} ${MAPNIK_AGG_SOURCES} ${AGG_SOURCES})
    target_compile_definitions(mapnik PRIVATE  -DMAPNIK_EXPORTS)
    set(MAPNIK_LIB_DEFINITION )
endif ()

target_compile_definitions(mapnik PUBLIC  ${MAPNIK_DEFS})

target_include_directories(mapnik INTERFACE ${mapnik_include_paths}  ${thirdparty_include_paths} )
target_link_libraries(mapnik PUBLIC
    ${thirdparty_libraries}
    Boost::boost Boost::filesystem Boost::system Boost::regex Boost::program_options Boost::system
    Freetype::Freetype
    ICU::uc
    PNG::PNG
    TIFF::TIFF
    ZLIB::ZLIB)

#file(GLOB libs
#        E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/*.lib
#        )
#message(${libs})
##link_libraries(E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_serialization-vc140-mt.lib)
#target_link_libraries(mapnik PUBLIC
#        E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/GlU32.Lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/OpenGL32.Lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DAnimation.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DCore.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DExtras.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DInput.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DLogic.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DQuick.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DQuickAnimation.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DQuickExtras.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DQuickInput.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DQuickRender.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DQuickScene2D.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt53DRender.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5AccessibilitySupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5AxBase.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5AxContainer.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5AxServer.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Charts.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Concurrent.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Core.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5DBus.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5DataVisualization.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Designer.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5DesignerComponents.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5DeviceDiscoverySupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5EdidSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5EglSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5EventDispatcherSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5FbSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5FontDatabaseSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Gamepad.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Gui.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Help.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Location.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Mqtt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Multimedia.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5MultimediaQuick.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5MultimediaWidgets.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Network.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5NetworkAuth.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5OpenGL.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5OpenGLExtensions.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5PacketProtocol.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5PlatformCompositorSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Positioning.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5PositioningQuick.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5PrintSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Purchasing.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Qml.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5QmlDebug.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Quick.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5QuickControls2.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5QuickParticles.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5QuickShapes.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5QuickTemplates2.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5QuickTest.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5QuickWidgets.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Script.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5ScriptTools.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Scxml.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Sensors.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5SerialPort.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Sql.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Svg.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Test.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5ThemeSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5UiTools.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5WebChannel.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Widgets.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5WindowsUIAutomationSupport.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/Qt5Xml.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/atk-1.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_atomic-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_chrono-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_container-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_context-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_contract-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_coroutine-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_date_time-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_exception-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_fiber-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_filesystem-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_graph-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_iostreams-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_locale-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_log-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_log_setup-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_math_c99-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_math_c99f-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_math_c99l-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_math_tr1-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_math_tr1f-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_math_tr1l-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_program_options-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_python37-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_random-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_regex-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_serialization-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_stacktrace_noop-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_stacktrace_windbg-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_stacktrace_windbg_cached-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_system-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_thread-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_timer-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_type_erasure-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_unit_test_framework-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_wave-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/boost_wserialization-vc140-mt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/bz2.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/cairo-gobject.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/cairo.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/double-conversion.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/epoxy.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/expat.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/fontconfig.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/freetype.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gailutil-3.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gdal.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gdk-3.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gdk_pixbuf-2.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/geos.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/geos_c.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gif.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gio-2.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/glib-2.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gmodule-2.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gobject-2.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gthread-2.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/gtk-3.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/harfbuzz.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/hdf5.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/hdf5_hl.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/icudt.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/icuin.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/icuio.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/icutu.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/icuuc.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/jpeg.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libEGL.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libGLESv2.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libcharset.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libcurl.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libeay32.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libffi.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libhdf5.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libhdf5_hl.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libiconv.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libintl.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libpng16.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libpq.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libszip.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/libxml2.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/lzma.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/netcdf.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/openjp2.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pango-1.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pangocairo-1.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pangoft2-1.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pangowin32-1.0.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcre.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcre16.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcre2-16.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcre2-32.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcre2-8.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcre32.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcrecpp.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pcreposix.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/pixman-1.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/proj.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/python37.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/shp.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/sqlite3.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/ssleay32.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/szip.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/tiff.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/tiffxx.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/turbojpeg.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/webp.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/webpdecoder.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/webpdemux.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/zlib.lib E:/Personal/SideWorks/vcpkg/installed/x64-windows/lib/zstd.lib
#        )


install(TARGETS mapnik
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin)

add_subdirectory(src/json)
add_subdirectory(src/wkt)

# ideally we should also generate mapnik-config

if (WITH_INPUT_CSV)
    add_subdirectory(plugins/input/csv)
endif()

if (WITH_INPUT_GDAL)
    find_package(GDAL REQUIRED)
    add_subdirectory(plugins/input/gdal)
endif()

if (WITH_INPUT_GEOBUF)
    # TODO insert protozero here
    add_subdirectory(plugins/input/geobuf)
endif()

if (WITH_INPUT_GEOJSON)
    add_subdirectory(plugins/input/geojson)
endif()

if (WITH_INPUT_OGR)
    add_subdirectory(plugins/input/ogr)
endif()

if (WITH_INPUT_PGRASTER)
    find_package(PostgreSQL REQUIRED)
    add_subdirectory(plugins/input/pgraster)
endif()

if (WITH_INPUT_POSTGIS)
    find_package(PostgreSQL REQUIRED)
    add_subdirectory(plugins/input/postgis)
endif()

if (WITH_INPUT_RASTER)
    add_subdirectory(plugins/input/raster)
endif()

if (WITH_INPUT_SHAPE)
    add_subdirectory(plugins/input/shape)
endif()

if (WITH_INPUT_SQLITE)
    find_package(sqlite3 REQUIRED)
    add_subdirectory(plugins/input/sqlite)
endif()

if (WITH_INPUT_TOPOJSON)
    add_subdirectory(plugins/input/topojson)
endif()

if (WITH_INPUTS)
    message(STATUS "Input plugins:")
    if(WITH_INPUT_CSV      )
        message(STATUS "   - csv     ")
    endif()
    if(WITH_INPUT_GDAL     )
        message(STATUS "   - gdal    ")
    endif()
    if(WITH_INPUT_GEOBUF   )
        message(STATUS "   - geobuf  ")
    endif()
    if(WITH_INPUT_GEOJSON  )
        message(STATUS "   - geojson ")
    endif()
    if(WITH_INPUT_OGR      )
        message(STATUS "   - ogr     ")
    endif()
    if(WITH_INPUT_PGRASTER )
        message(STATUS "   - pgraster")
    endif()
    if(WITH_INPUT_POSTGIS  )
        message(STATUS "   - postgis ")
    endif()
    if(WITH_INPUT_RASTER   )
        message(STATUS "   - raster  ")
    endif()
    if(WITH_INPUT_SHAPE    )
        message(STATUS "   - shape   ")
    endif()
    if(WITH_INPUT_SQLITE   )
        message(STATUS "   - sqlite  ")
    endif()
    if(WITH_INPUT_TOPOJSON )
        message(STATUS "   - topojson")
    endif()
else()
    message(STATUS "Input plugins OFF")
endif()

if(WITH_DEMO)
    add_subdirectory(demo/c++)
endif()

if(WITH_VIEWER)
    find_package(Qt5 COMPONENTS Widgets REQUIRED)
    add_subdirectory(demo/viewer)
endif()

if(WITH_UTILS)
    add_subdirectory(utils/mapnik-render)
    add_subdirectory(utils/shapeindex)
endif()
