GENERATED += $(addprefix src/,$(LIB_NAMES))

GET_SRC = src/get-src

src/wxwidgets: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/wxWidgets/wxWidgets/archive/v3.1.0.tar.gz'

src/lua: src/makefile.mk
	$(GET_SRC) $@ 'http://www.lua.org/ftp/lua-5.2.4.tar.gz'
	cd src && cat lua.patch | patch -p1

src/wxlua: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/pkulchenko/wxlua/archive/wxwidgets310.zip'
	mv $@/wxLua $@_
	rm -rf $@
	mv $@_ $@
	cd src && cat wxlua.patch | patch -p1

src/lua-cjson: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/mpx/lua-cjson/archive/2.1.0.tar.gz'

src/luafilesystem: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/keplerproject/luafilesystem/archive/v_1_6_3.tar.gz'

src/zlib: src/makefile.mk
	$(GET_SRC) $@ 'http://zlib.net/zlib-1.2.8.tar.gz'

src/libzip: src/makefile.mk
	$(GET_SRC) $@ 'https://nih.at/libzip/libzip-1.1.3.tar.gz'

src/lua-zip: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/henry4k/lua-zip/archive/master.zip'
	cd src && cat lua-zip.patch | patch -p1
