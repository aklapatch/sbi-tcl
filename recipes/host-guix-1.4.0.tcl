set ver 1.4.0
set name guix
set plat host
set guile "$plat-guile-3.0.9"
set guile_dir [get_pkg_dir $guile]
set dest_dir [get_pkg_dir "$plat-$name-$ver"]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$guile" \
	srcs "https://ftpmirror.gnu.org/gnu/guix/guix-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "CFLAGS=-pipe CPPFLAGS=-pipe PKG_CONFIG_PATH=$guile_dir/lib/pkgconfig --with-system=i686-linux --with-store-dir=$dest_dir/gnu-store " \
    paths "$guile_dir/bin"
]
