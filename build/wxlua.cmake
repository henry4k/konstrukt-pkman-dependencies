set(BUILD_SHARED_LIBS TRUE CACHE BOOL "")
set(wxWidgets_CONFIG_EXECUTABLE "${CMAKE_CURRENT_LIST_DIR}/wxwidgets/wx-config" CACHE STRING "")
#set(wxWidgets_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/wxwidgets" CACHE PATH "")
#set(wxWidgets_LIB_DIR "${CMAKE_CURRENT_LIST_DIR}/wxwidgets/lib" CACHE PATH "")
#set(wxWidgets_CONFIGURATION "mswu" CACHE PATH "")
#set(wxWidgets_MONOLITHIC ON CACHE BOOL "")
#set(wxWidgets_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/wxwidgets/include" CACHE STRING "")
set(wxWidgets_LIBRARY_DIRS "${CMAKE_CURRENT_LIST_DIR}/wxwidgets/lib" CACHE STRING "")
set(wxLua_LUA_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/lua/src" CACHE STRING "")
set(wxLua_LUA_LIBRARY "${CMAKE_CURRENT_LIST_DIR}/lua/src/liblua.a" CACHE STRING "")
set(wxLua_LUA_LIBRARY_BUILD_SHARED FALSE CACHE BOOL "")
set(wxLua_LUA_LIBRARY_USE_BUILTIN FALSE CACHE BOOL "")
#set(wxLua_LUA_LIBRARY_VERSION "5.2" CACHE STRING "")