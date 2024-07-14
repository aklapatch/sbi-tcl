set ver c6a8aa30006d997eff0d60fd37b0e62b8aa0ea50
set name zapcc
set plat host
set ::cmake "$plat-cmake-3.30.0"
set ::ninja "$plat-ninja-1.12.1"
set ::ccache "$plat-ccache-3.7.12"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::cmake $::ninja $::ccache" \
	srcs "https://github.com/yrnkrn/zapcc/archive/$ver.zip" \
]

proc build {name ver inst_dir build_dir} {
    set src_folder_name "$name-$ver"
    file mkdir build
    cd build
    # Use ccache
    exec_stdout "cmake -G Ninja -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_TARGETS_TO_BUILD=x86_64 -DLLVM_CCACHE_BUILD=ON -DLLVM_ENABLE_WARNINGS=OFF ../$src_folder_name"
    exec_stdout "ninja -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "ninja install -j 3"
}
