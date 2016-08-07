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

SASS_DIR=deps/libsass
SASS_LIB=libsass.a

# Set Erlang-specific compile and linker flags
ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR) -Ldeps/libsass/lib -lsass -Ideps/libsass -Ideps/libsass/include
ERL_LDFLAGS ?= -Ideps/libsass -Ideps/libsass/include -Ldeps/libsass/lib

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
	$(CC) $^ $(ERL_LDFLAGS) $(LDFLAGS) -static-libstdc++ -Bstatic -lsass -lm -lc -o $@


clean: libsass_src-clean sass-clean

sass-clean:
	rm -f priv/*.so src/*.o && rm -rf _build

libsass_src-clean:
	$(MAKE) -C $(SASS_DIR) clean

libsass_src-make:
	$(MAKE) -C $(SASS_DIR) -j $(NPROCS)

