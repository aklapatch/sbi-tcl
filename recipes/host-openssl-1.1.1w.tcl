set ver 1.1.1w
set name openssl
# TODO: This package needs linux-headers for alpine linux. Make a package for those
# headers based on the alpine linux package.
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://www.openssl.org/source/old/1.1.1/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
    cfg_cmd "config" \
    cfg_flags "\
    no-shared \
    no-zlib \
    no-async 
    no-comp \
        no-idea \
        no-mdc2 \
        no-rc5 \
        no-ec2m \
        no-ssl3 \
        no-seed \
        no-weak-ssl-ciphers" \
	make_flags "-j 3" \
]

proc build {name ver inst_dir build_dir} {
    cd $name-$ver
    exec_stdout "./config
        --prefix=$inst_dir \
        no-shared \
        no-zlib \
        no-async 
        no-comp \
        no-idea \
        no-mdc2 \
        no-rc5 \
        no-ec2m \
        no-ssl3 \
        no-seed \
        no-weak-ssl-ciphers"
   exec_stdout "make -j 3"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
