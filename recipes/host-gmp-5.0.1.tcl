set ver 5.0.1
set name gmp
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	cfg_flags "--disable-shared" \
	make_flags "-j 4" \
]
