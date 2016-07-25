GENERATED = .gitignore package package.tar.gz
LIB_NAMES = wxwidgets lua wxlua lua-cjson luafilesystem

all: package.tar.gz

clean:
	rm -rf $(GENERATED)

.PHONY: all clean

.gitignore: Makefile
	echo '# FILE IS GENERATED BY MAKE - DO NOT EDIT' > $@
	echo '/config.mk' >> $@
	for file in $(GENERATED) ; do \
		echo /$$file >> $@ ; \
	done

package: Makefile $(addprefix build/,$(filter-out glm,$(LIB_NAMES)))
	rm -rf $@
	mkdir $@
	mkdir $@/licenses
	# wxwidgets:
	cp src/wxwidgets/docs/licence.txt $@/licenses/wxwidgets.txt
	#cp build/wxwidgets/OpenAL32$(SHARED_LIBRARY_POSTFIX) $@/
	# lua:
	cp lua-LICENSE.txt $@/licenses/lua.txt
	#cp build/lua/src/liblua.a $@/
	# wxlua:
	cp src/wxlua/wxLua/docs/license.txt $@/licenses/wxlua.txt
	#cp build/lua/src/liblua.a $@/
	# lua-cjson:
	cp src/lua-cjson/LICENSE $@/licenses/lua-cjson.txt
	cp build/lua-cjson/cjson.$(SHARED_LIBRARY_POSTFIX) $@/
	# luafilesystem:
	cp src/luafilesystem/LICENSE $@/licenses/luafilesystem.txt
	cp build/luafilesystem/lfs.$(SHARED_LIBRARY_POSTFIX) $@/


package.tar.gz: Makefile package
	tar czvf $@ -C package .

include config.mk
include src/makefile.mk
include build/makefile.mk
