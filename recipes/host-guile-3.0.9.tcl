set ver 3.0.9
set name guile
set plat host
set unistring "$plat-libunistring-1.2"
set unistring_dir [get_pkg_dir $unistring]
set gmp "$plat-gmp-5.0.1"
set gmp_dir [get_pkg_dir $gmp]
set ffi "$plat-libffi-3.4.6"
set ffi_dir [get_pkg_dir $ffi]
set bdw "$plat-bdwgc-8.2.6"
set bdw_dir [get_pkg_dir $bdw]
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$unistring $gmp $ffi $bdw" \
	srcs "ttps://ftp.gnu.org/gnu/$name/$name-$ver.tar.xz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
	cfg_flags "PKG_CONFIG_PATH=$ffi_dir/lib/pkgconfig:$bdw_dir/lib/pkgconfig CFLAGS=-pipe CPPFLAGS=-pipe --with-libunistring-prefix=$unistring_dir --with-libgmp-prefix=$gmp_dir " \
]
