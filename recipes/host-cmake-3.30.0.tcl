set ver 3.30.0
set name cmake
set plat host
set ::openssl "$plat-openssl-1.1.1w"
set ::ninja "$plat-ninja-1.12.1"
set ::ccache $plat-ccache-3.7.12
set ::ncurses $plat-ncurses-6.5
set rep_info [dict create \
	plat $plat \
	name $name \
	ver  $ver \
    build_needs "$::openssl $::ninja $::ccache $::ncurses" \
	srcs "https://github.com/Kitware/CMake/releases/download/v$ver/cmake-$ver.tar.gz" \
]

proc build {name ver inst_dir build_dir} {
    set openssl_dir [get_pkg_dir $::openssl]
    cd $name-$ver
    set ncurses_dir [get_pkg_dir $::ncurses]
    set ncurses_inc [file join $ncurses_dir include]
    set ncurses_inc2 [file join $ncurses_inc ncursesw]
    set ncurses_lib [file join $ncurses_dir lib libncursesw.a]
    exec_stdout "./bootstrap --prefix=$inst_dir --parallel=3 --generator=Ninja --no-system-libs CFLAGS=-pipe CXXFLAGS=-pipe --enable-ccache -- -DOPENSSL_ROOT_DIR=$openssl_dir -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_MAKE_PROGRAM=ninja -DBUILD_CursesDialog=ON \"-DCURSES_INCLUDE_PATH=$ncurses_inc;$ncurses_inc2\" -DCURSES_LIBRARY=$ncurses_lib"
    exec_stdout "ninja -j 3"
}

proc install {pkg_name inst_dir build_dir} {
    exec_stdout "ninja install"
}
