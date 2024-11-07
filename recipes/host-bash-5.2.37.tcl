set ver 5.2.37
set name bash
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/bash/bash-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --enable-readline --enable-static-link" \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
