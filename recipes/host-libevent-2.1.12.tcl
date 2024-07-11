set ver 2.1.12
set name libevent
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://github.com/libevent/libevent/releases/download/release-$ver-stable/libevent-$ver-stable.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "${name}-$ver-stable" \
        "--prefix=$inst_dir --disable-openssl" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
