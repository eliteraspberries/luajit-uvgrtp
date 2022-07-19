MAKEFILE:=  $(firstword $(MAKEFILE_LIST))
MAKEDIR:=   $(shell cd $(dir $(MAKEFILE)) && pwd)

TARGETS:= \
	x86_64-apple-darwin \
	arm64-apple-darwin \
	armv7-apple-ios \
	arm64-apple-ios

AR:=		ar
CC:=		clang
CXX:=		clang++
LD:=		$(CXX)
CPPFLAGS:=
CFLAGS:=
CXXFLAGS:=
LDFLAGS:=

CPPFLAGS+=	-D_DARWIN_C_SOURCE=1

ENV:= \
	AR="$(AR)" \
	CC="$(CC)" \
	CXX="$(CXX)" \
	LD="$(LD)" \
	CPPFLAGS="$(CPPFLAGS)" \
	CXXFLAGS="$(CXXFLAGS)" \
	LDFLAGS="$(LDFLAGS)"

.PHONY: so
so:
	for target in $(TARGETS); do \
		env $(ENV) TARGET="$$target" $(MAKE) so; \
	done

.PHONY: install-so
install-so:

.PHONY: install
install:

.PHONY: cleanup
cleanup:
	rm -rf build/*-apple-*/*.o

.PHONY: clean
clean: cleanup
	rm -rf build/*-apple-*/*
