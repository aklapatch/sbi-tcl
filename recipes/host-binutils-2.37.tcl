set ver 2.37
set name binutils
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.xz" \
	cd_dest "$name-$ver" \
	make_flags "-j 3" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --disable-nls" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
