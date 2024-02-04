set ver 5.0.1
set name gmp
set rep_info [dict create \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 4" \
]
