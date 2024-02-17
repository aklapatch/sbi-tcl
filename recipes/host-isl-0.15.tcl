set ver 0.15
set name isl
set gmp_dir [get_pkg_dir host-gmp-5.0.1]
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://libisl.sourceforge.io/$name-$ver.tar.xz" \
	cd_dest "$name-$ver" \
	build_needs host-gmp-5.0.1 \
	make_flags "-j 4" \
	cfg_flags "--with-gmp-prefix=$gmp_dir" \
]
