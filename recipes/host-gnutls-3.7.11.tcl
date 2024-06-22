set ver 3.7.11
set name gnutls
set plat host
set guile "$plat-guile-3.0.9"
set guile_dir [get_pkg_dir $guile]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$guile" \
	srcs "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-$ver.tar.xz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "CFLAGS=-pipe CPPFLAGS=-pipe PKG_CONFIG_PATH=$guile_dir/lib/pkgconfig " \
    paths "$guile_dir/bin"
]
