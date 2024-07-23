set ver 18.1.8
set name llvm-project
set plat host
set ::cmake "$plat-cmake-3.30.0"
set ::ninja "$plat-ninja-1.12.1"
set ::ccache "$plat-ccache-3.7.12"
set ::python "$plat-python-3.12.4"
set ::zstd "$plat-zstd-1.5.6"
set ::zlib "$plat-zlib-1.3.1"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::cmake $::ninja $::ccache $::python $::zstd $::zlib" \
	srcs "https://github.com/llvm/llvm-project/releases/download/llvmorg-$ver/llvm-project-$ver.src.tar.xz" \
]

proc build {name ver inst_dir build_dir} {
    cd "$name-$ver.src"
    # Use ccache
    set zstd_dir [file join [get_pkg_dir $::zstd] lib pkgconfig]
    set zlib_dir [file join [get_pkg_dir $::zlib] lib pkgconfig]
    set ::env(PKG_CONFIG_PATH) "$zstd_dir:$zlib_dir"
    exec_stdout "cmake -S llvm -B build -G Ninja -DLLVM_PARALLEL_LINK_JOBS=1 -DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;lld;lldb -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_CCACHE_BUILD=ON -DLLVM_ENABLE_WARNINGS=OFF -DCMAKE_INSTALL_PREFIX=$inst_dir"
    exec_stdout "ninja -C llvm -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "ninja check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "ninja -j 3 install"
}
