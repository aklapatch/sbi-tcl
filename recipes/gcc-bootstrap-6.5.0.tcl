set ver 6.5.0
set base_name gcc
set name "$base_name-bootstrap"
set url https://ftp.gnu.org/gnu/

proc cfg_fn {pkg_short_name pkg_inst_dir} {
	set s_name "$base_name-$ver"
	file rename gmp-6.1.1 [file join $s_name gmp]
	file rename mpfr-3.1.4 [file join $s_name mpfr]
	file rename mpc-1.0.3 [file join $s_name mpc]

	file mkdir gcc-build
	cd gcc-build

	
	set cfg_log [file join $tmp_build_dir cfg-log.txt]
	exec_log_cmd "./configure --prefix=$pkg_inst_dir" $cfg_log
}

set rep_info [dict create \
	name $name \
	ver  $ver \
	srcs "$url/$base_name/$base_name-$ver/$base_name-$ver.tar.gz $url/gmp/gmp-6.1.1 $url/mpfr/mpfr-3.1.4.tar.gz $url/mpc/mpc-1.0.3.tar.gz" \
	build_needs "" \
	cfg_proc cfg_fn \
]
