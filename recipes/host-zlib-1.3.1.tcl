set ver 1.3.1
set name zlib
set plat host
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://zlib.net/fossils/zlib-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "--static" \
]
