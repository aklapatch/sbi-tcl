set ver host
set name kernel-headers
set ::rsync "host-rsync-3.3.0"
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
    build_needs "$::rsync"
]
# example URL: https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.11.7.tar.xz
proc install {pkg_name inst_dir build_dir} {
	set ver_out [exec uname -r]
    puts "uname -r kernel version=$ver_out"
	regexp "(\\d+\\.\\d+\\.\\d+).*" $ver_out whole_match cap_ver
	puts "Captured version=$cap_ver"
	puts $whole_match
	set ver_char [string index $cap_ver 0]
	set url "https://cdn.kernel.org/pub/linux/kernel/v$ver_char.x/linux-$cap_ver.tar.xz"
	set out_file [file tail $url]
	exec_stdout "wget -nc $url -O $build_dir/$out_file"
	exec_stdout "tar xf $out_file"
	set arch $::tcl_platform(machine)
	exec_stdout "make -C linux-$cap_ver ARCH=$arch INSTALL_HDR_PATH=$inst_dir headers_install"
}
