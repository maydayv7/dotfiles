.POSIX:

NAME = stagit
VERSION = 1.2

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/man
DOCPREFIX = ${PREFIX}/share/doc/${NAME}

LIBGIT_INC = -I/usr/local/include
LIBGIT_LIB = -L/usr/local/lib -lgit2

# use system flags.
STAGIT_CFLAGS = ${LIBGIT_INC} ${CFLAGS}
STAGIT_LDFLAGS = ${LIBGIT_LIB} ${LDFLAGS}
STAGIT_CPPFLAGS = -D_XOPEN_SOURCE=700 -D_DEFAULT_SOURCE -D_BSD_SOURCE

# Uncomment to enable workaround for older libgit2 which don't support this
# option. This workaround will be removed in the future *pinky promise*.
#STAGIT_CFLAGS += -DGIT_OPT_SET_OWNER_VALIDATION=-1

SRC = \
	stagit.c\
	stagit-index.c
COMPATSRC = \
	reallocarray.c\
	strlcat.c\
	strlcpy.c
BIN = \
	stagit\
	stagit-index
DOC = \
	README.md
HDR = compat.h

COMPATOBJ = \
	reallocarray.o\
	strlcat.o\
	strlcpy.o

OBJ = ${SRC:.c=.o} ${COMPATOBJ}

all: ${BIN}

.o:
	${CC} -o $@ ${LDFLAGS}

.c.o:
	${CC} -o $@ -c $< ${STAGIT_CFLAGS} ${STAGIT_CPPFLAGS}

dist:
	rm -rf ${NAME}-${VERSION}
	mkdir -p ${NAME}-${VERSION}
	cp -f ${HDR} ${SRC} ${COMPATSRC} ${DOC} \
		Makefile favicon.png render.py stagit.1 stagit-index.1 \
		${NAME}-${VERSION}
	# make tarball
	tar -cf - ${NAME}-${VERSION} | \
		gzip -c > ${NAME}-${VERSION}.tar.gz
	rm -rf ${NAME}-${VERSION}

${OBJ}: ${HDR}

stagit: stagit.o ${COMPATOBJ}
	${CC} -o $@ stagit.o ${COMPATOBJ} ${STAGIT_LDFLAGS}

stagit-index: stagit-index.o ${COMPATOBJ}
	${CC} -o $@ stagit-index.o ${COMPATOBJ} ${STAGIT_LDFLAGS}

clean:
	rm -f ${BIN} ${OBJ} ${NAME}-${VERSION}.tar.gz

install: all
	# installing executable files.
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f ${BIN} ${DESTDIR}${PREFIX}/bin
	cp -f render.py ${DESTDIR}${PREFIX}/bin/render
	chmod 755 ${DESTDIR}${PREFIX}/bin/render
	for f in ${BIN}; do chmod 755 ${DESTDIR}${PREFIX}/bin/$$f; done
	# installing example files.
	mkdir -p ${DESTDIR}${DOCPREFIX}
	cp -f favicon.png README.md ${DESTDIR}${DOCPREFIX}
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp -f stagit.1 stagit-index.1 ${DESTDIR}${MANPREFIX}/man1

uninstall:
	# removing executable files.
	for f in ${BIN}; do rm -f ${DESTDIR}${PREFIX}/bin/$$f; done
	rm -f ${DESTDIR}${PREFIX}/bin/render
	rm -f ${DESTDIR}${MANPREFIX}/man1/stagit.1 ${DESTDIR}${MANPREFIX}/man1/stagit-index.1
	# removing example files.
	rm -f \
		${DESTDIR}${DOCPREFIX}/favicon.png\
		${DESTDIR}${DOCPREFIX}/README.md
	-rmdir ${DESTDIR}${DOCPREFIX}

.PHONY: all clean dist install uninstall
