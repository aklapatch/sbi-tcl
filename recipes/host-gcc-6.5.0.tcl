set ver 6.5.0
set name gcc
set gmp_dir [get_pkg_dir host-gmp-4.3.2]
set mpfr_dir [get_pkg_dir host-mpfr-2.4.2]
set mpc_dir [get_pkg_dir host-mpc-0.8.1]
set isl_dir [get_pkg_dir host-isl-0.15]
set url https://ftp.gnu.org/gnu/
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "$url/$name/$name-$ver/$name-$ver.tar.gz" \
	build_needs "host-isl-0.15 host-gmp-4.3.2 host-mpc-0.8.1 host-mpfr-2.4.2" \
	make_flags "-j 2" \
	cd_dest $name-$ver \
	cfg_flags "CFLAGS=-pipe --with-isl=$isl_dir --with-gmp=$gmp_dir --with-mpfr=$mpfr_dir --disable-multilib --with-mpc=$mpc_dir" \
	cfg_type "at-new-dir" \
]
