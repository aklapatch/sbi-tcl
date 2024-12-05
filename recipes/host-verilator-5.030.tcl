set ver 5.030
set plat host
set name verilator
set ::cmake "$plat-cmake-3.30.0"
set ::ninja "$plat-ninja-1.12.1"
set ::python "$plat-python-3.12.4"
set ::bison "$plat-bison-3.8.2"
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
    build_needs "$::cmake $::ninja $::python $::bison" \
	srcs "https://github.com/verilator/verilator/archive/refs/tags/v$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    exec_stdout "cmake -S $name-$ver -B build -G Ninja -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=$inst_dir"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "ninja -C build check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "ninja -C build -j 3 install"
}
