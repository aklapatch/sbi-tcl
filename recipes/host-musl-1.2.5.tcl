set ver 1.2.5
set name musl
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://musl.libc.org/releases/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	cfg_flags  " --disable-shared" \
	make_flags "-j 4" \
]
