ERLANG_PATH:=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS_SASS=-g -fPIC -O3
CFLAGS=$(CFLAGS_SASS) -Ilibsass_src -Ilibsass_src/include -Llibsass_src/lib -lsass
ERLANG_FLAGS=-I$(ERLANG_PATH)
CC?=clang
EBIN_DIR=ebin

ifeq ($(shell uname),Darwin)
	OPTIONS=-dynamiclib -undefined dynamic_lookup
endif

NIF_SRC= src/sass_nif.c
SASS_DIR=libsass_src
SASS_LIB=libsass.a

all: sass_ex

priv/sass.so: ${NIF_SRC}
	$(MAKE) -C $(SASS_DIR) static -j5
	$(CC) $(CFLAGS) $(ERLANG_FLAGS) -static -shared $(OPTIONS) $(NIF_SRC) -o $@ 2>&1 >/dev/null

sass_ex:
	mix compile

$(SASS_LIB):
	git submodule update --init && \
	cd libsass_src && \
	git submodule update --init && \
	CFLAGS="$(CFLAGS_SASS)" $(MAKE) 2>&1 >/dev/null

libsass_src/configure.sh:
	git submodule update --init
	./configure

libsass_src-clean:
	test ! -f $(SASS_LIB) || \
	  ($(MAKE) -C $(SASS_DIR) clean)

sass_ex-clean:
	rm -rf $(EBIN_DIR) test/tmp share/* _build

sass_nif-clean:
	rm -rf priv/sass.*

docs:
	MIX_ENV=docs mix do clean, deps.get, compile, docs

docs-clean:
	rm -rf docs

test:
	MIX_ENV=test mix do clean, deps.get, compile, test

clean: libsass_src-clean sass_ex-clean sass_nif-clean docs-clean

.PHONY: all sass_ex clean distclean libsass_src-clean libsass_src-distclean test
