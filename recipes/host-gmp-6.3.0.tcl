set ver 6.3.0
set name gmp
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://ftp.gnu.org/gnu/$name/$name-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    cd $name-$ver
    exec >&@stdout ./configure --prefix=$inst_dir --with-pic --enable-static --disable-shared
    exec >&@stdout make -j 3
}

proc check {pkg_name inst_dir build_dir} {
    exec >&@stdout make check -j 3
}

proc install {pkg_name inst_dir build_dir} {
    exec >&@stdout make install
}


