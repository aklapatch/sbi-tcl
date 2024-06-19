set ver 8.2.6
set name bdwgc
set plat host
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://github.com/ivmai/bdwgc/releases/download/v8.2.6/gc-8.2.6.tar.gz" \
	cd_dest "gc-$ver" \
	make_flags "-j 4" \
	cfg_flags "CFLAGS=-pipe CPPFLAGS=-pipe " \
]
