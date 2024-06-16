set ver 1.1.1w
set name openssl
set rep_info [dict create \
	plat host \
	name $name \
	ver  $ver \
	srcs "https://www.openssl.org/source/old/1.1.1/$name-$ver.tar.gz" \
	cd_dest "$name-$ver" \
    cfg_cmd "config" \
    # TODO: This package needs linux-headers for alpine linux. Make a package for those
    # headers based on the alpine linux package.
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
	make_flags "-j 2" \
]
