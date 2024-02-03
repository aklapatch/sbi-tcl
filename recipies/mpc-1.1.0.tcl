set ver 1.1.0
set name mpc
set gmp_dir [get_pkg_dir gmp-5.0.1]
set mpfr_dir [get_pkg_dir mpfr-4.0.0]
set rep_info [dict create \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	build_needs {gmp-5.0.1 mpfr-4.0.0} \
	cfg_flags "--with-gmp=$gmp_dir --with-mpfr=$mpfr_dir" \
]
