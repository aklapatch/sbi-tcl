set ver 3.10
set name nettle
set plat host
# GMP is needed for libhogweed, which we need for gnutls
set gmp "$plat-gmp-6.3.0"
set gmp_dir [get_pkg_dir $gmp]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$gmp" \
	srcs "https://ftp.gnu.org/gnu/nettle/nettle-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "CFLAGS=-pipe CPPFLAGS=-pipe --with-lib-path=$gmp_dir/lib --with-include-path=$gmp_dir/include " \
]
