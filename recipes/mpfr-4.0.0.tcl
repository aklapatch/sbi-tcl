set ver 4.0.0
set name mpfr
set rep_info [dict create \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	build_needs gmp-5.0.1 \
	cfg_flags "--with-gmp=[get_pkg_dir gmp-5.0.1]" \
]
