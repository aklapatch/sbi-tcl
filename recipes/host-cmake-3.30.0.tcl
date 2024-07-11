set ver 3.30.0
set name cmake
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://github.com/Kitware/CMake/releases/download/v$ver/cmake-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir " \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
