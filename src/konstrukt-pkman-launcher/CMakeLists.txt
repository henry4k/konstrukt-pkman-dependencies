cmake_minimum_required(VERSION 2.8)

project(konstrukt-pkman-launcher CXX)


set(ICON_FILE_NAME "icon.ico" CACHE PATH "")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/launcher.rc.in
               ${CMAKE_CURRENT_BINARY_DIR}/launcher.rc @ONLY)
add_executable(launcher WIN32 launcher.cpp ${CMAKE_CURRENT_BINARY_DIR}/launcher.rc)
