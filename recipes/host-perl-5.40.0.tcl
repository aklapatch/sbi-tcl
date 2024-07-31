set ver 5.40.0
set name perl
set plat host
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
	srcs "https://www.cpan.org/src/5.0/perl-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    cd $name-$ver
    exec_stdout "./Configure -de -Dprefix=$inst_dir"
    exec_stdout "make -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
