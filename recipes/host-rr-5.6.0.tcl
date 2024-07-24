set ver 5.6.0
set name rr
set plat host
set ::cmake "$plat-cmake-3.30.0"
set ::ninja "$plat-ninja-1.12.1"
set ::ccache "$plat-ccache-3.7.12"
set ::python "$plat-python-3.12.4"
set ::zstd "$plat-zstd-1.5.6"
set ::cap "$plat-capnproto-1.0.2"
set ::zlib "$plat-zlib-1.3.1"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::cmake $::ninja $::ccache $::python $::zstd $::cap $::zlib" \
	srcs "https://github.com/rr-debugger/rr/archive/refs/tags/$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    puts "WARNING: This does not build on musl systems!"
    set src_folder_name "$name-$ver"
    # Use ccache
    set cap_dir [file join [get_pkg_dir $::cap] lib pkgconfig]
    set zlib_dir [file join [get_pkg_dir $::zlib] lib pkgconfig]
    set ::env(PKG_CONFIG_PATH) "$cap_dir:$zlib_dir"
    exec_stdout "cmake -G Ninja -B build -Dstaticlibs=ON -Ddisable32bit=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$inst_dir $src_folder_name"
    cd build
    exec_stdout "ninja -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "ninja check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "ninja install"
}
