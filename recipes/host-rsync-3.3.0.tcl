set ver 3.3.0
set name rsync
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://github.com/RsyncProject/rsync/archive/refs/tags/v$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --with-pic --enable-static --disable-shared --disable-md2man --disable-openssl --disable-zstd --disable-lz4 --disable-xxhash" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
