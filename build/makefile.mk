GENERATED += build/toolchain.cmake $(addprefix build/,$(LIB_NAMES))

AUTOTOOLS_ARGS  = "CC=$(CC)"
AUTOTOOLS_ARGS += "CXX=$(CXX)"
AUTOTOOLS_ARGS += "CPP=$(CPP)"
AUTOTOOLS_ARGS += "CFLAGS=$(CFLAGS)"
AUTOTOOLS_ARGS += "CXXFLAGS=$(CXXFLAGS)"
AUTOTOOLS_ARGS += "--with-sysroot=$(ROOT_PATH)"
AUTOTOOLS_ARGS += "--host=$(AUTOTOOLS_HOST)"

build/toolchain.cmake: build/makefile.mk
	echo '# FILE IS GENERATED BY MAKE - DO NOT EDIT' > $@
	echo 'set(CMAKE_SYSTEM_NAME $(CMAKE_SYSTEM_NAME))' >> $@
	echo 'set(CMAKE_C_COMPILER "$(CC)")' >> $@
	echo 'set(CMAKE_CXX_COMPILER "$(CXX)")' >> $@
	echo 'set(CMAKE_RC_COMPILER "$(WINDRES)")' >> $@
	echo 'set(CMAKE_C_FLAGS "$(CFLAGS)")' >> $@
	echo 'set(CMAKE_CXX_FLAGS "$(CXXFLAGS)")' >> $@
	echo 'set(CMAKE_FIND_ROOT_PATH "$(ROOT_PATH)")' >> $@
	echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)' >> $@
	echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)' >> $@
	echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)' >> $@

define build-cmake
	rm -rf $@
	mkdir $@
	cd $@ && cmake $(abspath src/$(notdir $@)) -DCMAKE_TOOLCHAIN_FILE=$(abspath build/toolchain.cmake) -C$(abspath build/$(notdir $@).cmake)
	cd $@ && $(MAKE)
endef

define build-autotools
	rm -rf $@
	cp -R src/$(notdir $@) $@
	cd $@ && ./configure $(AUTOTOOLS_ARGS)
	cd $@ && touch Makefile.in # Workaround for a weird timing bug .. or so
	cd $@ && make
endef

build/wxwidgets: AUTOTOOLS_ARGS += "--with-msw"
build/wxwidgets: AUTOTOOLS_ARGS += "--enable-monolithic"
#build/wxwidgets: AUTOTOOLS_ARGS += "--disable-all-features"
#build/wxwidgets: AUTOTOOLS_ARGS += "--enable-utf8only"
build/wxwidgets: src/wxwidgets build/toolchain.cmake
	$(build-autotools)

build/lua: src/lua
	rm -rf $@
	cp -R src/lua $@
	cd $@ && $(MAKE) PLAT=generic \
					 "CC=$(CC)" \
					 "CFLAGS=$(CFLAGS)" \
					 "LDFLAGS=$(LDFLAGS)" \
					 "AR=$(AR) rcu" \
					 "RANLIB=$(RANLIB)"

build/wxlua: src/wxlua build/wxwidgets build/lua build/toolchain.cmake
	rm -rf $@
	mkdir $@
	cd $@ && cmake $(abspath src/wxlua/wxLua) -DCMAKE_TOOLCHAIN_FILE=$(abspath build/toolchain.cmake) -C$(abspath build/$(notdir $@).cmake)
	cd $@ && $(MAKE)