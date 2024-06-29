set ver 3.8.5
set name gnutls
set plat host
set guile "$plat-guile-3.0.9"
set guile_dir [get_pkg_dir $guile]
set nettle "$plat-nettle-3.10"
set nettle_dir [get_pkg_dir $nettle]
set gmp "$plat-gmp-6.3.0"
set gmp_dir [get_pkg_dir $gmp]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$guile $nettle" \
	srcs "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-$ver.tar.xz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "PKG_CONFIG_PATH=$guile_dir/lib/pkgconfig:$nettle_dir/lib/pkgconfig --with-pic --enable-static --enable-shared --with-included-libtasn1 --with-included-unistring --without-p11-kit --disable-openssl-compatibility --disable-ktls GMP_CFLAGS=-I$gmp_dir/include GMP_LIBS=-L$gmp_dir/lib" \
    paths "$guile_dir/bin"
]
