set ver 1.0.2
set name capnproto
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://capnproto.org/capnproto-c++-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-c++-$ver" \
        "--prefix=$inst_dir --with-pic --enable-static --disable-shared" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
