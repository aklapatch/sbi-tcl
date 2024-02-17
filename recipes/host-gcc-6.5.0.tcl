set ver 6.5.0
set name gcc
set gmp_dir [get_pkg_dir host-gmp-5.0.1]
set mpfr_dir [get_pkg_dir host-mpfr-4.0.0]
set mpc_dir [get_pkg_dir host-mpc-1.1.0]
set isl_dir [get_pkg_dir host-isl-0.15]
set url https://ftp.gnu.org/gnu/
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "$url/$name/$name-$ver/$name-$ver.tar.gz" \
	build_needs "host-isl-0.15 host-gmp-5.0.1 host-mpc-1.1.0 host-mpfr-4.0.0" \
	make_flags "-j 3" \
	cd_dest $name-$ver \
	cfg_flags "--with-isl=$isl_dir --with-gmp=$gmp_dir --with-mpfr=$mpfr_dir --disable-multilib --with-mpc=$mpc_dir" \
	cfg_type "at-new-dir" \
]