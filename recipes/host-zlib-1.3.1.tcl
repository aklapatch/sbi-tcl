set ver 1.3.1
set name zlib
set plat host
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://zlib.net/fossils/zlib-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    set cflags ""
    if {[info exists ::env(CFLAGS)]} {
        set clfags $::env(CFLAGS)
    }
    set ::env(CFLAGS) "$cflags -fPIC"
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --static --64" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}


