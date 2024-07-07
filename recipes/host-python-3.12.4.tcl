set ver 3.12.4
set name python
set plat host
set ::openssl "$plat-openssl-1.1.1w"
set ::zlib "$plat-zlib-1.3.1"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::openssl $::zlib" \
	srcs "https://www.python.org/ftp/python/$ver/Python-$ver.tgz" \
]

proc build {name ver inst_dir build_dir} {
    set openssl_dir [get_pkg_dir $::openssl]
    set zlib_dir [get_pkg_dir $::zlib]
    autotools_build \
        "Python-$ver" \
        "--prefix=$inst_dir PKG_CONFIG_PATH=$openssl_dir/lib/pkgconfig:$zlib_dir/lib/pkgconfig --with-openssl=$openssl_dir --with-openssl-rpath=$openssl_dir/lib --disable-shared \"CFLAGS=-fPIC -g0\"" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}


