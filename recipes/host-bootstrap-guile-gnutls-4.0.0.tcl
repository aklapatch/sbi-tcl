set ver 4.0.0
set name guile-gnutls
set plat host
set unistr "$plat-libunistring-1.2"
set unistr_dir [get_pkg_dir $unistr]
set ffi "$plat-libffi-3.4.6"
set ffi_dir [get_pkg_dir $ffi]
set nettle "$plat-nettle-3.10"
set nettle_dir [get_pkg_dir $nettle]
set guile "$plat-guile-3.0.9"
set guile_dir [get_pkg_dir $guile]
set gnutls "$plat-gnutls-3.8.5"
set gnutls_dir [get_pkg_dir $gnutls]
set gmp "$plat-gmp-6.3.0"
set gmp_dir [get_pkg_dir $gmp]

proc pre_cfg_proc {pkg_name inst_dir build_dir} {
    set pre_log [file join $build_dir pre-cfg-log.txt]
    cd guile-v4.0.0
    exec_log_cmd "./bootstrap" $pre_log
}

set ::env(PKG_CONFIG_PATH) "$guile_dir/lib/pkgconfig"
# Add gmp to guile flags because it needs them
set guile_l_flags [exec pkg-config --libs guile-3.0]
set guile_l_flags "$guile_l_flags -L$gmp_dir/lib -lgmp -L$unistr_dir/lib -lunistring -L$ffi_dir/lib -lffi"
# Get rid of the deprecated warning because it breaks the build.
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$guile $gnutls $nettle $unistr $ffi" \
    srcs "https://gitlab.com/gnutls/guile/-/archive/v4.0.0/guile-v4.0.0.tar.gz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
    cd_dest "guile-v4.0.0" \
	cfg_flags "PKG_CONFIG_PATH=$gnutls_dir/lib/pkgconfig:$nettle_dir/lib/pkgconfig:$guile_dir/lib/pkgconfig CFLAGS=-Wno-deprecated \"GUILE_LIBS=$guile_l_flags\" --enable-static --disable-srp-authentication" \
    pre_cfg_proc pre_cfg_proc \
    paths "$guile_dir/bin" \
]
	#cfg_flags "PKG_CONFIG_PATH=$gnutls_dir/lib/pkgconfig:$nettle_dir/lib/pkgconfig:$guile_dir/lib/pkgconfig CFLAGS=-Wno-deprecated \"GUILE_LIBS=$guile_l_flags\" --disable-shared --disable-srp-authentication" \
