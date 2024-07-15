set ver 6.5
set name ncurses
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/ncurses/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --disable-shared --enable-pc-files --enable-static --with-pkg-config-libdir=[get_pkg_dir host-$name-$ver]/lib" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
