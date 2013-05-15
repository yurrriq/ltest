LFE_DIR = ./deps/lfe
LFE_EBIN = $(LFE_DIR)/ebin
LFE = $(LFE_DIR)/bin/lfe
LFEC = $(LFE_DIR)/bin/lfec
ERL_LIBS = $(LFE_DIR):./
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit

get-deps:
	rebar get-deps

clean-ebin:
	-rm $(OUT_DIR)/*.beam

clean-eunit:
	-rm -rf $(TEST_OUT_DIR)

compile: get-deps clean-ebin
	rebar compile
	ERL_LIBS=$(ERL_LIBS) $(LFEC) -o $(OUT_DIR) $(SOURCE_DIR)/*.lfe

compile-tests: clean-eunit
	mkdir -p $(TEST_OUT_DIR)
	ERL_LIBS=$(ERL_LIBS) $(LFEC) -o $(TEST_OUT_DIR) $(TEST_DIR)/*_tests.lfe

shell:
	ERL_LIBS=$(ERL_LIBS) $(LFE) -pa $(TEST_OUT_DIR)

clean: clean-ebin clean-eunit
	rebar clean

check: TEST_MODS = $(wildcard $(TEST_OUT_DIR)/*.beam)
check: compile compile-tests
	@#rebar eunit verbose=1 skip_deps=true
	for FILE in $(wildcard $(TEST_OUT_DIR)/*.beam); do \
	F1="$$(basename $$FILE)"; F2=$${F1%.*}; \
	echo $$F2; done|sed -e :a -e '$$!N; s/\n/,/; ta' | \
	ERL_LIBS=$(ERL_LIBS) \
	xargs -I % erl -W0 -pa $(TEST_OUT_DIR) -noshell \
	-eval "eunit:test([%], [verbose])" \
	-s init stop