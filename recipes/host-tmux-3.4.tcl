set ver 3.4
set name tmux 
set lev_dir [get_pkg_dir host-libevent-2.1.12]
set nc_dir [get_pkg_dir host-ncurses-6.5]
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
    build_needs "host-libevent-2.1.12 host-ncurses-6.5" \
	srcs "https://github.com/tmux/tmux/releases/download/$ver/tmux-$ver.tar.gz" \
	cd_dest "$name-$ver" \
    cfg_flags "--enable-static PKG_CONFIG_LIBDIR=$lev_dir/lib/pkgconfig:$nc_dir/lib"\
	make_flags "-j 2" \
]
