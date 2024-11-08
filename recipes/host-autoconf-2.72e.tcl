set ver 2.72e
set name autoconf
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://alpha.gnu.org/pub/gnu/autoconf/$name-$ver.tar.gz" \
	build_needs "host-m4-1.4.19 host-perl-5.40.0 host-make-4.4"
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir " \
        "-j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
