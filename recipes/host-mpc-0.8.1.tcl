set ver 0.8.1
set name mpc
set gmp_dir [get_pkg_dir host-gmp-4.3.2]
set mpfr_dir [get_pkg_dir host-mpfr-2.4.2]
# NOTE: The multiprecision web site is slow last I used it, but the GNU ftp site doesn't have MPC 0.8.1.
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://www.multiprecision.org/downloads/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 4" \
	build_needs {host-gmp-4.3.2 host-mpfr-2.4.2} \
	cfg_flags "--disable-shared --with-gmp=$gmp_dir --with-mpfr=$mpfr_dir" \
]
