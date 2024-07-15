set ver 9.1
set name vim
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://www.vim.org/downloads/$name-$ver.tar.bz2" \
	build_needs "host-ncurses-6.5 host-tcl-8.6.14 host-lua-5.4.7" \
]

proc build {name ver inst_dir build_dir} {
    set nc_dir [get_pkg_dir host-ncurses-6.5]
    set l_dir [get_pkg_dir host-lua-5.4.7]
    set t_dir [get_pkg_dir host-tcl-8.6.14]
    autotools_build \
        "${name}91" \
        "--prefix=$inst_dir --with-tlib=ncursesw --with-lua-prefix=$l_dir --enable-luainterp=dynamic --enable-tclinterp=dynamic --with-tclsh=$t_dir/bin/tclsh --enable-multibyte CFLAGS=-I$nc_dir/include \"LDFLAGS=-lncursesw -L$nc_dir/lib\"" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
