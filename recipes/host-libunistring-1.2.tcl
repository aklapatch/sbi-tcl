set ver 1.2
set name libunistring
set plat "host"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "--with-pic" \
]
