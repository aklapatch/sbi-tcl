set ver 2.45.2
set name git
set plat host
set ::openssl "$plat-openssl-1.1.1w"
set ::zlib "$plat-zlib-1.3.1"
set ::asciidoc "$plat-asciidoc-10.2.1"
set ::python "$plat-python-3.12.4"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://github.com/git/git/archive/refs/tags/v$ver.tar.gz" \
    build_needs "$::openssl $::zlib $::asciidoc $::python" \
]

proc build {name ver inst_dir build_dir} {
    cd $name-$ver
    exec_stdout "make configure"
    set ssl_dir [get_pkg_dir $::openssl]
    set zlib_dir [get_pkg_dir $::zlib]
    set py_dir [get_pkg_dir $::python]
    exec_stdout "./configure --prefix=$inst_dir --with-zlib=$zlib_dir \"CFLAGS=-I$ssl_dir/include -I$zlib_dir/include\" \"LIBS=$ssl_dir/lib/libssl.a $zlib_dir/lib/libz.a\" --with-python=$py_dir/bin"
    exec_stdout "make -j 3"

}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
