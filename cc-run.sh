#!/bin/sh
compiler=$(basename "$0" | sed 's|-run$||')
src=""
args=""
exeargs=""

if ! command -v "$compiler" >/dev/null 2>&1; then
	echo "$(basename "$0"): error: can't find compiler: '$compiler'" >&2
	exit 1
fi

for arg in "$@"; do
	if [ "$src" = "" -a -e "$arg" -o "$arg" = "-" ]; then
		src="$arg"
	elif [ "$src" != "" ]; then
		exeargs="$exeargs $arg"
	else
		args="$args $arg"
	fi
done

case $compiler in
	cc|gcc|gcc-*|clang|clang-*|tcc)
		if [ "$src" = '-' ]; then
			args="$args -x c"
		fi
		args="$args $CPPFLAGS $CFLAGS $LDFLAGS";;
	c++|g++|g++-*|clang++|clang++-*)
		if [ "$src" = '-' ]; then
			args="$args -x c++"
		fi
		args="$args $CPPFLAGS $CXXFLAGS $LDFLAGS"
esac

exe=$(mktemp -t cc-run) || exit 1
if ! $compiler $args $src -o $exe; then
	rm -f $exe
	exit 1
fi

$exe $exeargs
ret=$?
rm -f $exe
exit $ret
