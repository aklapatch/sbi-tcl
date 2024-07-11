set ver 9.1
set name vim
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://www.vim.org/downloads/$name-$ver.tar.bz2" \
	build_needs "host-ncurses-6.5" \
]

proc build {name ver inst_dir build_dir} {
    set nc_dir [get_pkg_dir host-ncurses-6.5]
    autotools_build \
        "${name}91" \
        "--prefix=$inst_dir --with-tlib=ncursesw CFLAGS=-I$nc_dir/include \"LDFLAGS=-lncursesw -L$nc_dir/lib\"" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
