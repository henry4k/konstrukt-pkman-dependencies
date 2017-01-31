GENERATED += src/wxwidgets \
             src/lua \
             src/wxlua \
             src/lua-cjson \
             src/luafilesystem\
             src/zlib \
             src/libzip \
             src/lua-zip \
             src/lanes \
             src/luasocket \
             src/argparse \
             src/semver \
             src/StackTracePlus \
             src/statemachine

GET_SRC = src/get-src

src/wxwidgets:
	$(GET_SRC) $@ 'https://github.com/wxWidgets/wxWidgets/archive/v3.1.0.tar.gz'

src/lua:
	$(GET_SRC) $@ 'https://github.com/LuaDist/lua/archive/5.2.4.tar.gz'

src/wxlua:
	$(GET_SRC) $@ 'https://github.com/pkulchenko/wxlua/archive/wxwidgets311.zip'
	mv $@/wxLua $@_
	rm -rf $@
	mv $@_ $@
	cd src && cat wxlua.patch | patch -p1

src/lua-cjson:
	$(GET_SRC) $@ 'https://github.com/mpx/lua-cjson/archive/2.1.0.tar.gz'

src/luafilesystem:
	$(GET_SRC) $@ 'https://github.com/LuaDist/luafilesystem/archive/1.6.2.tar.gz'

src/zlib:
	$(GET_SRC) $@ 'http://zlib.net/zlib-1.2.10.tar.gz'

src/libzip:
	$(GET_SRC) $@ 'https://nih.at/libzip/libzip-1.1.3.tar.gz'

src/lua-zip:
	$(GET_SRC) $@ 'https://github.com/henry4k/lua-zip/archive/master.zip'
	cd src && cat lua-zip.patch | patch -p1

src/lanes:
	$(GET_SRC) $@ 'https://github.com/LuaLanes/lanes/archive/v3.10.0.tar.gz'

src/luasocket:
	$(GET_SRC) $@ 'https://github.com/LuaDist/luasocket/archive/3.0-rc1.tar.gz'


# Lua only libraries:

src/argparse:
	$(GET_SRC) $@ 'https://github.com/mpeterv/argparse/archive/0.5.0.tar.gz'

src/semver:
	$(GET_SRC) $@ 'https://github.com/kikito/semver.lua/archive/v1.2.1.tar.gz'

src/StackTracePlus:
	$(GET_SRC) $@ 'https://github.com/ignacio/StackTracePlus/archive/0.1.2-1.tar.gz'

src/statemachine:
	$(GET_SRC) $@ 'https://github.com/henry4k/lua-state-machine/archive/master.zip'
