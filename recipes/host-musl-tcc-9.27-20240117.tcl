set date 202401117
set ver 9.27
set name tcc
set rep_info [dict create \
	plat "host-musl" \
	name $name \
	ver  "$ver-$date" \
	srcs "https://repo.or.cz/tinycc.git/snapshot/7d1bbc80d4978c128b8ebead42485d7a79624dcd.tar.gz" \
	cd_dest "tinycc-7d1bbc8" \
	cfg_flags  " --enable-static --config-musl" \
	make_flags "-j 2" \
]
