AR?=		ar
CC?=		clang
CXX?=		clang++
LD?=		$(CXX)

ifeq ("$(TARGET)","")
TARGET:=	$(shell $(CXX) $(CXXFLAGS) -dumpmachine | sed -e 's/[0-9.]*$$//')
endif
SYS:=		$(shell echo "$(TARGET)" | awk -F- '{print $$3}')

CFLAGS+=	--target=$(TARGET)
CXXFLAGS+=	--target=$(TARGET)
CXXFLAGS+=	-stdlib=libc++
CXXFLAGS+=	-std=c++11
LDFLAGS+=	-stdlib=libc++ -lc++

ifeq ("$(SYS)","darwin")
SDKROOT:=	$(shell xcrun --sdk macosx --show-sdk-path)
AR:=		$(shell xcrun --sdk macosx --find $(AR))
CC:=		$(shell xcrun --sdk macosx --find $(CC))
CXX:=		$(shell xcrun --sdk macosx --find $(CXX))
CPPFLAGS+=	-isysroot $(SDKROOT)
CFLAGS+=	--sysroot=$(SDKROOT)
CXXFLAGS+=	--sysroot=$(SDKROOT)
LDFLAGS+=	--sysroot=$(SDKROOT)
CFLAGS+=	-mmacosx-version-min=10.9
CXXFLAGS+=	-mmacosx-version-min=10.9
LDFLAGS+=	--target=$(TARGET)
SOEXT:=		.dylib
endif

ifeq ("$(SYS)","ios")
SDKROOT:=	$(shell xcrun --sdk iphoneos --show-sdk-path)
AR:=		$(shell xcrun --sdk iphoneos --find $(AR))
CC:=		$(shell xcrun --sdk iphoneos --find $(CC))
CXX:=		$(shell xcrun --sdk iphoneos --find $(CXX))
CPPFLAGS+=	-isysroot $(SDKROOT)
CFLAGS+=	--sysroot=$(SDKROOT)
CXXFLAGS+=	--sysroot=$(SDKROOT)
LDFLAGS+=	--sysroot=$(SDKROOT)
CFLAGS+=	-miphoneos-version-min=9.0
CXXFLAGS+=	-miphoneos-version-min=9.0
LDFLAGS+=	-Wl,-ios_version_min,9.0
LDFLAGS+=	--target=$(TARGET)
SOEXT:=		.dylib
endif

SOEXT?=		.so

ifeq ($(shell uname -s),Darwin)
DYLD_LIBRARY_PATH:=	$(shell pwd)/build/$(TARGET)/lib:$(DYLD_LIBRARY_PATH)
LUA:=				DYLD_LIBRARY_PATH="$(DYLD_LIBRARY_PATH)" luajit
else
LUA:=				luajit
endif
LUA_CPATH:=			$(shell pwd)/build/$(TARGET)/lib/?

.PHONY: lib
lib:

.PHONY: uvgrtp
uvgrtp: lib
	sh build-uvgrtp.sh

.PHONY: so
so: uvgrtp

.PHONY: check
check: uvgrtp.lua
	luacheck uvgrtp.lua

.PHONY: test
test: uvgrtp.lua so
	LUA_CPATH="$(LUA_CPATH)" $(LUA) uvgrtp.lua

.PHONY: cleanup
cleanup:
	rm -rf uvgRTP-[0-9].[0-9].[0-9]

.PHONY: clean
clean: cleanup
	rm -rf build/*
