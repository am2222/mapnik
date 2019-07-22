add_library(mapnik-input-sqlite SHARED
    sqlite_datasource.cpp
    sqlite_featureset.cpp)

target_link_libraries(mapnik-input-sqlite PUBLIC mapnik mapnik-wkt)
set_target_properties(mapnik-input-sqlite PROPERTIES PREFIX "")
set_target_properties(mapnik-input-sqlite PROPERTIES OUTPUT_NAME "sqlite")
set_target_properties(mapnik-input-sqlite PROPERTIES SUFFIX ".input")
