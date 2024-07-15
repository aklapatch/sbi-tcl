set ver 6.5.0
set name gcc
set gmp_dir [get_pkg_dir host-gmp-4.3.2]
set mpfr_dir [get_pkg_dir host-mpfr-2.4.2]
set mpc_dir [get_pkg_dir host-mpc-0.8.1]
set isl_dir [get_pkg_dir host-isl-0.15]

set url "https://ftp.gnu.org/gnu/"
set rep_info [dict create \
	plat host-musl \
	name $name \
	ver  $ver \
	srcs "$url/$name/$name-$ver/$name-$ver.tar.gz" \
	build_needs "host-isl-0.15 host-gmp-4.3.2 host-mpc-0.8.1 host-mpfr-2.4.2" \
	make_flags "-j 3" \
]

proc build {name ver inst_dir build_dir} {
    file mkdir gcc-build
    cd gcc-build
    set arch $::tcl_platform(machine)
    set gmp_dir [get_pkg_dir host-gmp-4.3.2]
    set mpfr_dir [get_pkg_dir host-mpfr-2.4.2]
    set mpc_dir [get_pkg_dir host-mpc-0.8.1]
    set isl_dir [get_pkg_dir host-isl-0.15]
    exec_stdout "../$name-$ver/configure --prefix=$inst_dir \"CFLAGS=-pipe -g0\" \"CXXFLAGS=-pipe -g0\" --disable-host-shared --disable-libquadmath --target=$arch-pc-linux-musl --host=$arch-pc-linux-musl --build=$arch-pc-linux-musl --with-isl=$isl_dir --with-gmp=$gmp_dir --with-mpfr=$mpfr_dir --disable-libsanitizer --disable-libgomp --disable-multilib --with-mpc=$mpc_dir --enable-languages=c,c++,lto --enable-lto --disable-bootstrap"
    exec_stdout "make -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
