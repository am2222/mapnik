add_executable(mapnik-render mapnik-render.cpp)
target_link_libraries(mapnik-render PRIVATE mapnik)
target_compile_definitions(mapnik-render PRIVATE ${IMGFORMAT_DEFS})
install(TARGETS mapnik-render DESTINATION bin)
