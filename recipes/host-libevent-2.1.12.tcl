set ver 2.1.12
set name libevent
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://github.com/libevent/libevent/releases/download/release-$ver-stable/libevent-$ver-stable.tar.gz" \
	cd_dest "$name-$ver-stable" \
	make_flags "-j 2" \
]
