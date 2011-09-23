# [g]make USE_xxxx=1 USE_xxxx=0
#
# USE_SHARED_CACHE   :   enable/disable a shared session cache (enabled by default)

DESTDIR =
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin

CFLAGS  = -O2 -g -std=c99 -fno-strict-aliasing -Wall -W -D_GNU_SOURCE
LDFLAGS = -lssl -lcrypto -lev
OBJS    = stud.o ringbuffer.o

all: realall

# Shared cache feature
ifneq ($(USE_SHARED_CACHE),0)
CFLAGS += -DUSE_SHARED_CACHE -DUSE_SYSCALL_FUTEX
OBJS   += shctx.o ebtree/libebtree.a
ALL    += ebtree

ebtree/libebtree.a: $(wildcard ebtree/*.c)
	make -C ebtree
ebtree:
	@[ -d ebtree ] || ( \
		echo "*** Download libebtree at http://1wt.eu/tools/ebtree/" ; \
		echo "*** Untar it and make a link named 'ebtree' to point on it"; \
		exit 1 )
endif

ALL += stud
realall: $(ALL)

stud: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

install: $(ALL)
	install -d $(DESTDIR)$(BINDIR)
	install stud $(DESTDIR)$(BINDIR)

clean:
	rm -f stud $(OBJS)


.PHONY: all realall
