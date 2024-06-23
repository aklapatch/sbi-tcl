set ver 4.0.0
set name guile-gnutls
set plat host
set nettle "$plat-nettle-3.10"
set nettle_dir [get_pkg_dir $nettle]
set guile "$plat-guile-3.0.9"
set guile_dir [get_pkg_dir $guile]
set gnutls "$plat-gnutls-3.8.5"
set gnutls_dir [get_pkg_dir $gnutls]
set gmp "$plat-gmp-6.3.0"
set gmp_dir [get_pkg_dir $gmp]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$guile $gnutls $nettle" \
    srcs "https://gitlab.com/-/project/40217954/uploads/9060bc55069cedb40ab46cea49b439c0/guile-gnutls-$ver.tar.gz"\
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "CFLAGS=-I$gmp_dir/include \"LDFLAGS=-L$gmp_dir/lib -lgmp\" PKG_CONFIG_PATH=$gnutls_dir/lib/pkgconfig:$nettle_dir/lib/pkgconfig:$guile_dir/lib/pkgconfig" \
    paths "$guile_dir/bin" \
]
