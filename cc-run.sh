#!/bin/sh
compiler=$(basename "$0" | sed 's|-run$||')
exe=$(mktemp -t cc-run) || exit 1
src=""
args=""
exeargs=""

if ! command -v "$compiler" >/dev/null 2>&1; then
	echo "$(basename "$0"): error: can't find compiler: '$compiler'" >&2
	exit 1
fi

for arg in "$@"; do
	if [ -e "$arg" ] && [ "$src" = "" ]; then
		src=$arg
	elif [ "$src" != "" ]; then
		exeargs="$exeargs $arg"
	else
		args="$args $arg"
	fi
done

case "$compiler" in
	cc|gcc|gcc-*|clang|clang-*)
		args="$args $CPPFLAGS $CFLAGS $LDFLAGS";;
	c++|g++|g++-*|clang++|clang++-*)
		args="$args $CPPFLAGS $CXXFLAGS $LDFLAGS"
esac

$compiler $args $src -o $exe || exit 1

$exe $exeargs
ret=$?
rm -f $exe
exit $ret
