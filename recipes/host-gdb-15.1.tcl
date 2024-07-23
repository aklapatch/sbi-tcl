set ver 15.1
set name gdb
set ::gmp "host-gmp-6.3.0"
set ::mpfr "host-mpfr-4.2.1"
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
    build_needs "$::gmp $::mpfr" \
]

proc build {name ver inst_dir build_dir} {
    set gmp_dir [get_pkg_dir $::gmp]
    set mpfr_dir [get_pkg_dir $::mpfr]
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --with-gmp=$gmp_dir --with-mpfr=$mpfr_dir --with-pic --enable-static --disable-shared" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
