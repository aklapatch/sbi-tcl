set ver 0.7.0
set name python-pexpect
set plat host
set ::python "$plat-python-3.12.4"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::python" \
]

proc build {name ver inst_dir build_dir} {
    # Just use pip to install the package
}
