set ver 1.1.0
set name mpc
set rep_info [dict create \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
	build_needs {gmp-5.0.1 mpfr-4.0.0} \
	cfg_flags {--with-gmp=../gmp-5.0.1 --with-mpfr=../mpfr-4.0.0} \
]
