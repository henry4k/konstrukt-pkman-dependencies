GENERATED += $(addprefix src/,$(LIB_NAMES))

GET_SRC = src/get-src

src/wxwidgets: src/makefile.mk
	$(GET_SRC) $@ 'https://github.com/wxWidgets/wxWidgets/archive/v3.1.0.tar.gz'
	#patch -u $@/CMakeLists.txt src/alure-CMakeLists.txt.patch
