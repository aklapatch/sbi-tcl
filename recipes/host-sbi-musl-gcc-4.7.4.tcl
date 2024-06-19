set ver 4.7.4
set name gcc
set gmp_dir [get_pkg_dir host-gmp-4.3.2]
set mpfr_dir [get_pkg_dir host-mpfr-2.4.2]
set mpc_dir [get_pkg_dir host-mpc-0.8.1]
set isl_dir [get_pkg_dir host-isl-0.15]
set musl_dir [get_pkg_dir host-musl-1.2.5]

set arch $::tcl_platform(machine)
set url "https://ftp.gnu.org/gnu/"
set rep_info [dict create \
	plat host-sbi-musl \
	name $name \
	ver  $ver \
	srcs "$url/$name/$name-$ver/$name-$ver.tar.gz" \
	build_needs "host-isl-0.15 host-gmp-4.3.2 host-mpc-0.8.1 host-mpfr-2.4.2 host-musl-1.2.5" \
	make_flags "-j 3" \
	cd_dest $name-$ver \
	cfg_flags "\"CC=$musl_dir/bin/musl-gcc\" \"LDFLAGS=-v\" --disable-host-shared --disable-libquadmath --enable-ld=yes --enable-libssp --enable-gold=yes --with-isl=$isl_dir --with-gmp=$gmp_dir --with-mpfr=$mpfr_dir --disable-libsanitizer --disable-libgomp --disable-multilib --with-mpc=$mpc_dir --enable-languages=c,c++,lto --enable-lto --disable-bootstrap" \
	cfg_type "at-new-dir" \
]
