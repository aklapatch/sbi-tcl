set ver 4.0.0
set name mpfr
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	build_needs host-gmp-5.0.1 \
	make_flags "-j 4" \
	cfg_flags "--disable-shared --with-gmp=[get_pkg_dir host-gmp-5.0.1]" \
]
