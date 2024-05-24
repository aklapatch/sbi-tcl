set ver 6.5
set name ncurses
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/ncurses/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 1" \
]
