set ver 0.8.1
set name mpc
# NOTE: The multiprecision web site is slow last I used it, but the GNU ftp site doesn't have MPC 0.8.1.
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://www.multiprecision.org/downloads/$name-$ver.tar.gz" \
	build_needs {host-gmp-4.3.2 host-mpfr-2.4.2} \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --with-pic --disable-shared --with-gmp=[get_pkg_dir host-gmp-4.3.2] --with-mpfr=[get_pkg_dir host-mpfr-2.4.2]" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
