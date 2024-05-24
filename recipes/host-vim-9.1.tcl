set ver 9.1
set name vim
set nc_dir [get_pkg_dir host-ncurses-6.5]
set cflags "-I$nc_dir/include"
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://www.vim.org/downloads/$name-$ver.tar.bz2" \
	build_needs "host-ncurses-6.5" \
	cd_dest "${name}91" \
	cfg_flags " --with-tlib=ncursesw CFLAGS=$cflags CPPFLAGS=$cflags LDFLAGS=-L$nc_dir/lib " \
	make_flags "-j 2" \
]
