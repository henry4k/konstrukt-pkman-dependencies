set(BUILD_SHARED_LIBS TRUE CACHE BOOL "")

execute_process(COMMAND sh "wx-config" "--version"
                WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/wxwidgets"
                OUTPUT_VARIABLE _wx_version)
execute_process(COMMAND sh "wx-config" "--cxxflags"
                WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/wxwidgets"
                OUTPUT_VARIABLE _wx_cxxflags)
execute_process(COMMAND sh "wx-config" "--libs"
                WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/wxwidgets"
                OUTPUT_VARIABLE _wx_ldflags)

string(STRIP "${_wx_version}" _wx_version)
string(STRIP "${_wx_cxxflags}" _wx_cxxflags)
string(STRIP "${_wx_ldflags}" _wx_ldflags)

set(wxWidgets_VERSION "${_wx_version}" CACHE STRING "")
set(wxLuaBind_COMPONENTS xrc richtext adv core xml net base CACHE STRING "")
set(wxLuaBind_ALL_COMPONENTS ${wxLuaBind_COMPONENTS} CACHE STRING "")
set(wxLuaBind_ALL_COMPONENTS_28 ${wxLuaBind_COMPONENTS} CACHE STRING "")
set(wxLuaBind_ALL_COMPONENTS_29 ${wxLuaBind_COMPONENTS} CACHE STRING "")
if(WIN32)
    set(wxWidgets_LIBRARIES ${_wx_ldflags} -lwsock32 CACHE STRING "")
else()
    set(wxWidgets_LIBRARIES ${_wx_ldflags} CACHE STRING "")
endif()
set(wxWidgets_CXX_FLAGS "-fpermissive ${_wx_cxxflags}" CACHE STRING "")

set(wxLua_LUA_INCLUDE_DIR "${LUA_INCLUDE_DIR}" CACHE STRING "")
set(wxLua_LUA_LIBRARY "${LUA_LIBRARY}" CACHE STRING "")
set(wxLua_LUA_LIBRARY_BUILD_SHARED FALSE CACHE BOOL "")
set(wxLua_LUA_LIBRARY_USE_BUILTIN FALSE CACHE BOOL "")
set(wxLua_LUA_LIBRARY_VERSION "5.2" CACHE STRING "")
