PREFIX ?= ~/.local
DESTDIR?=

all: cc-run

install: cc-run
	install -d ${DESTDIR}${PREFIX}/bin/
	install -m755 cc-run ${DESTDIR}${PREFIX}/bin/cc-run
	ln -sf cc-run ${DESTDIR}${PREFIX}/bin/c++-run

clean:
	rm -f cc-run
