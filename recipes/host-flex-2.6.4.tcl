set ver 2.6.4
set name flex
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --with-pic --enable-static --disable-shared" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
