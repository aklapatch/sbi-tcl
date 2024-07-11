set ver 3.4
set name tmux 
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
    build_needs "host-libevent-2.1.12 host-ncurses-6.5" \
	srcs "https://github.com/tmux/tmux/releases/download/$ver/tmux-$ver.tar.gz" \
	cd_dest "$name-$ver" \
]

proc build {name ver inst_dir build_dir} {
    set lev_dir [get_pkg_dir host-libevent-2.1.12]
    set nc_dir [get_pkg_dir host-ncurses-6.5]
    autotools_build \
        "${name}-$ver" \
        "--prefix=$inst_dir --enable-static --disable-shared PKG_CONFIG_LIBDIR=$lev_dir/lib/pkgconfig:$nc_dir/lib" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
