set ver 2.72e
set name autoconf
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://alpha.gnu.org/pub/gnu/autoconf/$name-$ver.tar.gz" \
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
