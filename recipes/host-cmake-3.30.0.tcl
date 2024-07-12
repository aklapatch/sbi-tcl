set ver 3.30.0
set name cmake
set plat host
set ::openssl "$plat-openssl-1.1.1w"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::openssl" \
	srcs "https://github.com/Kitware/CMake/releases/download/v$ver/cmake-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    set openssl_dir [get_pkg_dir $::openssl]
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --parallel=3 -- -DOPENSSL_ROOT_DIR=$openssl_dir -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
