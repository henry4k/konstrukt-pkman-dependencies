GENERATED = .gitignore package package.tar.gz
C_LIB_NAMES = wxwidgets lua wxlua lua-cjson luafilesystem zlib libzip lua-zip luasocket lanes
LUA_LIB_NAMES = argparse semver StackTracePlus statemachine

all: package.tar.gz

clean:
	rm -rf $(GENERATED)

.PHONY: all clean

.gitignore:
	echo '# FILE IS GENERATED BY MAKE - DO NOT EDIT' > $@
	echo '/config.mk' >> $@
	for file in $(GENERATED) ; do \
		echo /$$file >> $@ ; \
	done

package: $(addprefix src/,$(LUA_LIB_NAMES)) \
         $(addprefix src/,$(C_LIB_NAMES)) \
         $(addprefix build/,$(C_LIB_NAMES))
	rm -rf $@
	mkdir $@
	mkdir $@/licenses
	# wxwidgets:
	cp src/wxwidgets/docs/licence.txt $@/licenses/wxwidgets.txt
	cp build/wxwidgets/lib/*$(SHARED_LIBRARY_POSTFIX) $@/
	# lua:
	cp lua-LICENSE.txt $@/licenses/lua.txt
	cp build/lua/liblua$(SHARED_LIBRARY_POSTFIX) $@/
	cp build/lua/lua$(EXECUTABLE_POSTFIX) $@/
	# wxlua:
	cp src/wxlua/docs/licence.txt $@/licenses/wxlua.txt
	cp build/wxlua/bin/$(CMAKE_BUILD_TYPE)/*$(SHARED_LIBRARY_POSTFIX) $@/
	cp build/wxlua/bin/$(CMAKE_BUILD_TYPE)/wxLuaFreeze$(EXECUTABLE_POSTFIX) $@/
	# lua-cjson:
	cp src/lua-cjson/LICENSE $@/licenses/lua-cjson.txt
	cp build/lua-cjson/cjson$(SHARED_LIBRARY_POSTFIX) $@/
	# luafilesystem:
	cp luafilesystem-LICENSE.txt $@/licenses/luafilesystem.txt
	cp build/luafilesystem/lfs$(SHARED_LIBRARY_POSTFIX) $@/
	# zlib:
	cp zlib-LICENSE.txt $@/licenses/zlib.txt
	# libzip:
	cp src/libzip/LICENSE $@/licenses/libzip.txt
	cp build/libzip/lib/libzip$(SHARED_LIBRARY_POSTFIX) $@/
	# lua-zip:
	cp -r build/lua-zip/brimworks $@/
	cp lua-zip-LICENSE.txt $@/licenses/lua-zip.txt
	# lanes:
	cp src/lanes/src/lanes.lua $@/
	mkdir $@/lanes
	cp build/lanes/core$(SHARED_LIBRARY_POSTFIX) $@/lanes/
	cp src/lanes/COPYRIGHT $@/licenses/lanes.txt
	# luasocket:
	mkdir $@/mime
	mkdir $@/socket
	cp src/luasocket/src/ltn12.lua $@/
	cp src/luasocket/src/mime.lua  $@/
	cp src/luasocket/src/socket.lua  $@/
	cp src/luasocket/src/ftp.lua     $@/socket/
	cp src/luasocket/src/http.lua    $@/socket/
	cp src/luasocket/src/smtp.lua    $@/socket/
	cp src/luasocket/src/tp.lua      $@/socket/
	cp src/luasocket/src/url.lua     $@/socket/
	cp src/luasocket/src/headers.lua $@/socket/
	cp build/luasocket/mime/core$(SHARED_LIBRARY_POSTFIX) $@/mime/
	cp build/luasocket/socket/core$(SHARED_LIBRARY_POSTFIX) $@/socket/
	cp src/luasocket/LICENSE $@/licenses/luasocket.txt
	# argparse:
	cp src/argparse/src/argparse.lua $@/
	cp src/argparse/LICENSE $@/licenses/argparse.txt
	# semver:
	cp src/semver/semver.lua $@/
	cp src/semver/MIT-LICENSE.txt $@/licenses/semver.txt
	# StackTracePlus:
	cp src/StackTracePlus/src/StackTracePlus.lua $@/
	cp src/StackTracePlus/LICENSE $@/licenses/StackTracePlus.txt
	# statemachine:
	cp src/statemachine/statemachine.lua $@/
	cp src/statemachine/LICENSE $@/licenses/statemachine.txt
	# extra:
	if [ -n "$(EXTRA_FILES)" ]; then \
	    cp $(EXTRA_FILES) $@/ ; \
	fi
	# config.mk
	echo -n 'SYSTEM_NAME = ' > $@/config.mk
	echo '$(SYSTEM_NAME)' | tr '[:upper:]' '[:lower:]' >> $@/config.mk
	echo 'ARCHITECTURE = $(ARCHITECTURE)' >> $@/config.mk

package.tar.gz: package
	tar czvf $@ -C package .

include config.mk
include src/makefile.mk
include build/makefile.mk
