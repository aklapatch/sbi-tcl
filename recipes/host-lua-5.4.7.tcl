set ver 5.4.7
set name lua
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://www.lua.org/ftp/lua-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    cd $name-$ver
    exec_stdout "make all -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make test -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install INSTALL_TOP=$inst_dir"
}
