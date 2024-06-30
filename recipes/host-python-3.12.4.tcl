set ver 3.12.4
set name python
set plat host
set openssl "$plat-openssl-1.1.1w"
set openssl_dir [get_pkg_dir $openssl]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$openssl" \
	srcs "https://www.python.org/ftp/python/$ver/Python-$ver.tgz" \
	cd_dest "Python-$ver" \
	make_flags "-j 3" \
	cfg_flags "--with-openssl=$openssl_dir --with-openssl-rpath=$openssl_dir/lib" \
]
