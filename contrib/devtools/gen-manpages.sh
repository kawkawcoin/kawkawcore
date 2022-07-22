#!/bin/sh

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

KAWKAWD=${KAWKAWD:-$SRCDIR/kawkawd}
KAWKAWCLI=${KAWKAWCLI:-$SRCDIR/kawkaw-cli}
KAWKAWTX=${KAWKAWTX:-$SRCDIR/kawkaw-tx}
KAWKAWQT=${KAWKAWQT:-$SRCDIR/qt/kawkaw-qt}

[ ! -x $KAWKAWD ] && echo "$KAWKAWD not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
KAWVER=($($KAWKAWCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for kawkawd if --version-string is not set,
# but has different outcomes for kawkaw-qt and kawkaw-cli.
echo "[COPYRIGHT]" > footer.h2m
$KAWKAWD --version | sed -n '1!p' >> footer.h2m

for cmd in $KAWKAWD $KAWKAWCLI $KAWKAWTX $KAWKAWQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${KAWVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${KAWVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
