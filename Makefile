#ERLANG_PATH:=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
#CFLAGS_SASS=-g -fPIC -O3
#CFLAGS=$(CFLAGS_SASS) $(ERLANG_FLAGS) -Ilibsass_src -Ilibsass_src/include -Llibsass_src/lib -lsass -fPIC -static -fPIC
#ERLANG_FLAGS=-I$(ERLANG_PATH)
#CC ?= $(CROSSCOMPILER)gcc
#EBIN_DIR=ebin

#ifeq ($(shell uname),Darwin)
	#OPTIONS=-dynamiclib -undefined dynamic_lookup
#endif

#NIF_SRC= src/sass_nif.c
#SASS_DIR=libsass_src
#SASS_LIB=libsass.a

#all: sass_ex

#priv/sass.so: ${NIF_SRC}
	#$(MAKE) -C $(SASS_DIR) -j5
	#$(CC) $(CFLAGS) $(OPTIONS) $(NIF_SRC) -o $@ 2>&1 >/dev/null

#sass_ex:
	#mix compile

#$(SASS_LIB):
	#git submodule update --init && \
	#cd libsass_src && \
	#git submodule update --init && \
	#CFLAGS="$(CFLAGS_SASS)" $(MAKE) 2>&1 >/dev/null

#libsass_src/configure.sh:
	#git submodule update --init
	#./configure

#libsass_src-clean:
	#test ! -f $(SASS_LIB) || \
	  #($(MAKE) -C $(SASS_DIR) clean)

#sass_ex-clean:
	#rm -rf $(EBIN_DIR) test/tmp share/* _build

#sass_nif-clean:
	#rm -rf priv/sass.*

#docs:
	#MIX_ENV=docs mix do clean, deps.get, compile, docs

#docs-clean:
	#rm -rf docs

#test:
	#MIX_ENV=test mix do clean, deps.get, compile, test

#clean: libsass_src-clean sass_ex-clean sass_nif-clean docs-clean

#.PHONY: all sass_ex clean distclean libsass_src-clean libsass_src-distclean test


# Variables to override
#
# CC            C compiler
# CROSSCOMPILE	crosscompiler prefix, if any
# CFLAGS	compiler flags for compiling all C files
# ERL_CFLAGS	additional compiler flags for files using Erlang header files
# ERL_EI_LIBDIR path to libei.a
# LDFLAGS	linker flags for linking all binaries
# ERL_LDFLAGS	additional linker flags for projects referencing Erlang libraries

# Look for the EI library and header files
# For crosscompiled builds, ERL_EI_INCLUDE_DIR and ERL_EI_LIBDIR must be
# passed into the Makefile.
ifeq ($(ERL_EI_INCLUDE_DIR),)
ERL_ROOT_DIR = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ifeq ($(ERL_ROOT_DIR),)
   $(error Could not find the Erlang installation. Check to see that 'erl' is in your PATH)
endif
ERL_EI_INCLUDE_DIR = "$(ERL_ROOT_DIR)/usr/include"
ERL_EI_LIBDIR = "$(ERL_ROOT_DIR)/usr/lib"
endif

SASS_DIR=libsass_src
SASS_LIB=libsass.a

# Set Erlang-specific compile and linker flags
ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR) -Llibsass_src/lib -lsass -Ilibsass_src -Ilibsass_src/include
ERL_LDFLAGS ?= -Ilibsass_src -Ilibsass_src/include -Llibsass_src/lib -lstdc++

LDFLAGS += -fPIC -shared
CFLAGS ?= -fPIC -O2 -Wall -Wextra -Wno-unused-parameter
CC= $(CROSSCOMPILER)g++

ifeq ($(CROSSCOMPILE),)
ifeq ($(shell uname),Darwin)
LDFLAGS += -undefined dynamic_lookup
endif
endif

NPROCS := 1
OS := $(shell uname)
export NPROCS

ifeq ($J,)

ifeq ($(OS),Linux)
  NPROCS := $(shell grep -c ^processor /proc/cpuinfo)
endif # $(OS)

else
  NPROCS := $J
endif # $J

.PHONY: all clean

all: libsass_src-make priv/sass_nif.so

%.o: %.c
	$(CC) -c $(ERL_CFLAGS) $(CFLAGS) -o $@ $<

priv/sass_nif.so: src/sass_nif.o
	@mkdir -p priv
	$(CC) $^ $(ERL_LDFLAGS) $(LDFLAGS) -Bstatic -lsass -o $@


clean: libsass_src-clean sass-clean

sass-clean:
	rm -f priv/*.so src/*.o && rm -rf _build

libsass_src-clean:
	$(MAKE) -C $(SASS_DIR) clean

libsass_src-make:
	$(MAKE) -C $(SASS_DIR) -j $(NPROCS)

