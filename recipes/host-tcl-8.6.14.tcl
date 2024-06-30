set ver 8.6.14
set name tcl
set plat host
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "http://prdownloads.sourceforge.net/tcl/tcl$ver-src.tar.gz" \
	cd_dest "$name$ver/unix" \
	make_flags "-j 3" \
	cfg_flags "" \
]
