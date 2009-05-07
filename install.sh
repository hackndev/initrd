#!/bin/sh

myname="`basename $0`"
mypath="`dirname $0`"
myfiles="scripts/linuxrc scripts/loader/dialog scripts/loader/timedkill"

die() {
	echo "$1"
	echo "Instalation failed!"
	exit 1
}

checkforprg() {
	echo -n "Checking for \"$1\"..."
	if [ -z "`which "$1"`" ]; then
		echo "failed"
		die "Can't find \"$1\" which is essential."
	else
		echo "ok"
	fi
}

checkfordta() {
	echo -n "Checking file \"$1\"..."
	if [ -r "$1" ]; then
		echo "ok"
	else
		echo "failed"
		die "Can't read file \"$1\" which is essential."
	fi
}

if [ -z "$1" ] || [ "x$1" = "x-h" ] || [ "x$1" = "x--help" ]; then
	echo "$myname usage:"
	echo "	$myname destination"
	echo "Script will create ramdisk structure in directory provided as destination."
	exit 0
fi

checkforprg cp
checkforprg mkdir
checkforprg bzip2
checkforprg tar
checkforprg basename
checkforprg dirname

for i in root.tar.bz2 $myfiles; do
	checkfordta "$mypath/$i"
done

mkdir -p "$1" || die "Can't create destination directory"
echo "Installing content of ramdisk, please wait..."
( bzip2 -cd "$mypath/root.tar.bz2" | tar -xf - -C "$1" ) || die "Unpacking failed"

for i in $myfiles; do
	tmp="$1/`dirname "$i"`"
	mkdir -p "$tmp" || die "Can't create directory \"$tmp\"."
	cp "$mypath/$i" "$tmp" || die "Can't copy \"$mypath/$i\" to \"$tmp\"."
done

echo "Instalation complete"

