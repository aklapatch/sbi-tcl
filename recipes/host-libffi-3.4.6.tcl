set ver 3.4.6
set name libffi
set plat host
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://github.com/libffi/libffi/releases/download/v$ver/libffi-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "CFLAGS=-pipe CPPFLAGS=-pipe " \
]
