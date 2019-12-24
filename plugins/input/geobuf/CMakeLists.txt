add_library(mapnik-input-geobuf SHARED
    geobuf_datasource.cpp
    geobuf_featureset.cpp)

target_link_libraries(mapnik-input-geobuf PUBLIC mapnik)
set_target_properties(mapnik-input-geobuf PROPERTIES PREFIX "")
set_target_properties(mapnik-input-geobuf PROPERTIES OUTPUT_NAME "geobuf")
set_target_properties(mapnik-input-geobuf PROPERTIES SUFFIX ".input")
install(TARGETS mapnik-input-geobuf DESTINATION bin/plugins/input)
