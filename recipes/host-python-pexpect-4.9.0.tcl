set ::ver 4.9.0
set name python-pexpect
set plat host
set ::python "$plat-python-3.12.4"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $::ver \
	build_needs $::python \
	rm_needs $::python \
]

proc install {pkg_name inst_dir build_dir} {
	exec_stdout "python3 -m pip install pexpect==$::ver"
	# We need to make this folder so sbi knows we installed.
	puts "Making $inst_dir"
	file mkdir $inst_dir
}

# uninstall doesn't have tools added to it's path
proc uninstall {pkg_name inst_dir} {
	exec_stdout "python3 -m pip uninstall pexpect==$::ver"
}
