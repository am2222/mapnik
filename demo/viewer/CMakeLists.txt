add_executable(mapnik-viewer 
    about_dialog.cpp
    info_dialog.cpp
    layerdelegate.cpp
    layerlistmodel.cpp
    layerwidget.cpp
    layer_info_dialog.cpp
    main.cpp
    mainwindow.cpp
    mapwidget.cpp
    styles_model.cpp)

add_dependencies(mapnik-viewer mapnik)
target_link_libraries(mapnik-viewer PRIVATE mapnik)
