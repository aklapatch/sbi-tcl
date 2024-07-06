set ver 2.4.2
set name mpfr
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	build_needs host-gmp-4.3.2 \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --with-pic --disable-shared --with-gmp=[get_pkg_dir host-gmp-4.3.2]" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
