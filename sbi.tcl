#!/usr/bin/env tclsh

set import_rep ""
set build_rep ""

set sbi_dir [file normalize [file join ~ .sbi]]
set src_dir [file join $sbi_dir srcs]
set build_dir [file join $sbi_dir build]
set inst_dir [file join $sbi_dir installed]
set rep_dir [file join $sbi_dir recipies]
file mkdir $src_dir
file mkdir $build_dir
file mkdir $rep_dir

proc p_usage {} {
	puts "$argv0 usage: \[--build] \[--import] <recipe-path>"
}

for {set i 0} {$i < $argc} {incr i} {
	set arg [lindex $argv $i]
	switch $arg {
		--build {
			incr i
			set build_rep [lindex $argv $i]
		}
		--import {
			incr i
			set import_rep [lindex $argv $i]
			# TODO: import the folder to our hidden folders
		}
		default { error "Unrecognized arg $arg!" }
	}
}

if {[string length $build_rep] > 0} {
	# Build the recipe
	source $build_rep
	# Assume data is in rep_info 
	puts "Recipie info:"
	dict for {k v} $rep_info {
		puts "    - $k=$v"
	}
	puts
	set srcs [dict get $rep_info srcs]
	foreach src $srcs {
		if {[string length $src] == 0} {
			continue
		}
		set src_name [file tail $src]
		set save_path [file join $src_dir $src_name]
		if {[file exists $save_path] == 0} {
			puts "Downloading $src_name to $save_path"
			exec >&stdout curl -o $save_path $src
			puts "Downloaded $src_name to $save_path"
		}
	}

	# Exctrace source to build dir
	set short_name "[dict get $rep_info name]-[dict get $rep_info ver]"
	set tmp_build_dir [file join $build_dir $short_name]
	file delete -force -- $tmp_build_dir
	file mkdir $tmp_build_dir
	foreach src $srcs {
		if {[string length $src] == 0} {
			continue
		}
		set src_name [file tail $src]
		set save_path [file join $src_dir $src_name]
		puts "Extracting $save_path to $tmp_build_dir"
		exec >&@stdout tar -xf $save_path -C $tmp_build_dir
	}

	# Configure the build
	set pkg_inst_dir [file join $inst_dir $short_name]
	file delete -force -- $pkg_inst_dir
	set cfg_dir [file join $tmp_build_dir [dict get $rep_info cd_dest]]
	cd $cfg_dir
	# TODO: logging
	exec >&@stdout ./configure --prefix=$pkg_inst_dir

	# Make it
	exec >&@stdout make

	# Install it.
	exec >&@stdout make install
}
