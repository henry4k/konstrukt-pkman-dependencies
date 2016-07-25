GENERATED += $(addprefix src/,$(LIB_NAMES))

GET_SRC = src/get-src

src/wxwidgets: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/wxWidgets/wxWidgets/archive/v3.1.0.tar.gz'

src/lua: src/makefile.mk
		$(GET_SRC) $@ 'http://www.lua.org/ftp/lua-5.2.4.tar.gz'

src/wxlua: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/pkulchenko/wxlua/archive/wxwidgets311.zip'
	patch -u $@/wxLua/build/FindwxWidgets.cmake src/wxlua-FindwxWidgets.cmake.patch
	patch -u $@/wxLua/build/CMakewxAppLib.cmake src/wxlua-CMakewxAppLib.cmake.patch

src/lua-cjson: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/mpx/lua-cjson/archive/2.1.0.tar.gz'
