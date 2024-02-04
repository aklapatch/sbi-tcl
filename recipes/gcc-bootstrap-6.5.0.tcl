set ver 6.5.0
set name gcc-bootstrap
set url https://ftp.gnu.org/gnu/
proc cfg_fn {} {

}
set rep_info [dict create \
	name $name \
	ver  $ver \
	srcs "$url/$name/$name-$ver/$name-$ver.tar.gz $url/gmp/gmp-6.1.1 $rul/mpfr/mpfr-3.1.4.tar.gz $url/mpc/mpc-1.0.3.tar.gz" \
	cd_dest "$name-$ver" \
	build_needs "" \
]
