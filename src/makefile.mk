GENERATED += $(addprefix src/,$(LIB_NAMES))

GET_SRC = src/get-src

src/wxwidgets: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/wxWidgets/wxWidgets/archive/v3.1.0.tar.gz'

src/lua: src/makefile.mk
	$(GET_SRC) $@ 'http://www.lua.org/ftp/lua-5.2.4.tar.gz'
	patch -u $@/src/luaconf.h src/luaconf.h.patch

src/wxlua: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/pkulchenko/wxlua/archive/wxwidgets310.zip'
	mv $@/wxLua $@_
	rm -rf $@
	mv $@_ $@
	cd src && cat wxlua.patch | patch -p1
