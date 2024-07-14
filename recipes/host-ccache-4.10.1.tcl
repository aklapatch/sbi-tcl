set ver 4.10.1
set name ccache
set plat host
set ::ninja "$plat-ninja-1.12.1"
set ::cmake "$plat-cmake-3.30.0"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::ninja $::cmake" \
	srcs "https://github.com/ccache/ccache/releases/download/v$ver/ccache-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    set src_folder_name "$name-$ver"
    file mkdir build
    cd build
    # Use ccache
    exec_stdout "cmake -G Ninja -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=$inst_dir ../$src_folder_name"
    exec_stdout "ninja -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "ninja -j 3 install"
}
