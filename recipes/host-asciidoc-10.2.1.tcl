set ver 10.2.1
set name asciidoc
set plat host
set ::python "$plat-python-3.12.4"
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::python" \
    srcs "" \
]

proc build {name ver inst_dir build_dir} {
    # Just use pip to install the package
    exec_stdout "python3 -m pip install asciidoc==$ver"
}

# We don't have a way to remove this right now
proc install {pkg_name inst_dir build_dir} {
    file mkdir $inst_dirt
    set f [open [file join $inst_dir info.txt] w]
    puts $f "Run pip uninstall to uninstall this package"
    close $f
}


