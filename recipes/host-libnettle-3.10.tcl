set ver 3.10
set name nettle
set plat host
set guile "$plat-guile-3.0.9"
set guile_dir [get_pkg_dir $guile]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/nettle/nettle-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "CFLAGS=-pipe CPPFLAGS=-pipe " \
]
