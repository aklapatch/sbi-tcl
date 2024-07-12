set ver 1.12.1
set name ninja
set plat host
set ::python "$plat-python-3.12.4"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::python" \
	srcs "https://github.com/ninja-build/ninja/archive/refs/tags/v$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    set python_dir [get_pkg_dir $::python]
    set python_exec [file join $python_dir bin python3]
    cd $name-$ver
    exec_stdout "$python_exec configure.py --with-python=$python_exec --bootstrap"
}

proc install {pkg_name inst_dir build_dir} {
    set inst_bin [file join $inst_dir bin]
    file mkdir $inst_bin
    puts "Copying executable to $inst_bin"
    file copy ninja $inst_bin
}
