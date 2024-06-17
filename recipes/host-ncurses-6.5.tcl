set ver 6.5
set name ncurses
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/ncurses/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
    cfg_flags " --enable-static --enable-pc-files --with-pkg-config-libdir=[get_pkg_dir host-$name-$ver]/lib" \
	make_flags "-j 2" \
]
