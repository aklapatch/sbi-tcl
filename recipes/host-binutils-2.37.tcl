set ver 2.37
set name binutils
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.xz" \
	cd_dest "$name-$ver" \
	make_flags "-j 1" \
]
