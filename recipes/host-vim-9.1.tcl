set ver 9.1
set name vim
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://www.vim.org/downloads/$name-$ver.tar.bz2" \
	build_needs "host-ncurses-6.5" \
	cd_dest "${name}91" \
	make_flags "-j 1" \
]
