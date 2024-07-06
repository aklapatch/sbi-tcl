set ver 1.2.3
set name musl
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://musl.libc.org/releases/$name-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --enable-static --enable-wrapper --with-pic --disable-shared" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
