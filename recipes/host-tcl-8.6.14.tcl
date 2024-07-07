set ver 8.6.14
set name tcl
set plat host
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "http://prdownloads.sourceforge.net/tcl/tcl$ver-src.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name$ver/unix" \
        "--prefix=$inst_dir --disable-shared --enable-64bit" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}


