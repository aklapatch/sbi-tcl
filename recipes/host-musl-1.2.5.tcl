set ver 1.2.5
set name musl
set rep_info [dict create \
	plat "host" \
	name $name \
	ver  $ver \
	srcs "https://musl.libc.org/releases/$name-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    autotools_build \
        "$name-$ver" \
        "--prefix=$inst_dir --enable-static --enable-wrapper --with-pic --disable-shared" \
        "-j 3"

    set stack_check {
    extern void __stack_chk_fail(void);
    void __attribute__((visibility ("hidden"))) __stack_chk_fail_local(void) { __stack_chk_fail(); }
    }
    set c_file_name stack_check.c
    puts "Making stack check file"
    set c_file [open $c_file_name w]
    puts $c_file $stack_check
    close $c_file
    puts "Compiling stack check file"
    exec_stdout "gcc -c $c_file_name -o stack_check.o"
    puts "Making the stack check library"
    set f_dest [file join $inst_dir lib libssp_nonshared.a]
    file mkdir [file dirname $f_dest]
    exec_stdout "ar r $f_dest stack_check.o"
}

proc check {pkg_name inst_dir build_dir} {
    exec_stdout "make check -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "make install"
}
