CFLAGS =
LDFLAGS =

ME=libasn
C_OBJECTS=lib.o sfork.o regex.o thash.o tlist.o xstr.o wstr.o mmatic.o tsort.o fc.o select.o fcml.o

ifeq (,$(NOFIFOS))
C_OBJECTS+=fifos.o
endif

TARGETS=libasn.so libasn.a libasn_example fcmldump

include rules.mk

pcre/.libs/libpcre.a:
	./pcre-build.sh

libasn.so: pcre/.libs/libpcre.a $(C_OBJECTS)
	$(CC) $(C_OBJECTS) -shared -o libasn.so pcre/.libs/libpcre.a $(LDFLAGS)

libasn.a: $(C_OBJECTS) pcre/.libs/libpcre.a
	$(AR) rc libasn.a $(C_OBJECTS) pcre/.libs/libpcre.a

libasn_example: libasn_example.o libasn.a pcre/.libs/libpcre.a
	$(CC) libasn_example.o -o libasn_example libasn.a pcre/.libs/libpcre.a $(LDFLAGS)

fcmldump: fcmldump.o libasn.so
	$(CC) fcmldump.o -o fcmldump -L. -lasn $(LDFLAGS)

install: install-std
