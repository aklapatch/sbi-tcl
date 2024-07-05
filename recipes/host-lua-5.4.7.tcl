set ver 5.4.7
set name lua
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://www.lua.org/ftp/lua-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	cfg_flags "--with-pic --enable-static" \
	make_flags "-j 3" \
]
