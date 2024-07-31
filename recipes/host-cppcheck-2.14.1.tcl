set ver 2.14.1
set name cppcheck
set plat host
set ::cmake "$plat-cmake-3.30.0"
set ::ninja "$plat-ninja-1.12.1"
set ::python "$plat-python-3.12.4"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://github.com/danmar/cppcheck/archive/$ver.tar.gz" \
    build_needs "$::cmake $::ninja $::python" \
]

proc build {name ver inst_dir build_dir} {
    exec_stdout "cmake -S $name-$ver -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$inst_dir"
    exec_stdout "ninja -C build -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "ninja -C build -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "ninja -C build -j 3 install"
}
