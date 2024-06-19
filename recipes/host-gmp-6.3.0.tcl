set ver 6.3.0
set name gmp
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	cfg_flags "--disable-shared --enable-static CFLAGS=-fPIC CPPFLAGS=-fPIC" \
	make_flags "-j 3" \
]
