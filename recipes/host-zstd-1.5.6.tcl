set ver 1.5.6
set name zstd
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://github.com/facebook/zstd/releases/download/v$ver/zstd-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    cd $name-$ver
    exec_stdout "make -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make PREFIX=$inst_dir install"
}
