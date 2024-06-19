set ver 1.4.0
set name guix
set plat host
set guile "$plat-guile-3.0.9"
set guile_dir [get_pkg_dir $guile]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$guile" \
	srcs "https://ftpmirror.gnu.org/gnu/guix/guix-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "--disable-shared --enable-static PKG_CONFIG_PATH=$ffi_dir/lib/pkgconfig:$bdw_dir/lib/pkgconfig CFLAGS=-pipe CPPFLAGS=-pipe --with-libunistring-prefix=$unistring_dir --with-libgmp-prefix=$gmp_dir " \
]
