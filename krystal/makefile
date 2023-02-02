CRYSTAL = crystal
LDFLAGS = -Wl,-undefined,dynamic_lookup # https://github.com/grpc/grpc/issues/30976
LIBS = -levent -lgc # https://github.com/crystal-lang/crystal/issues/2888

crystal.bundle: crystal.o
	$(CC) -bundle -o $@ $^ $(LIBS) $(LDFLAGS)

crystal.o: crystal.cr
	$(CRYSTAL) build $< --cross-compile
