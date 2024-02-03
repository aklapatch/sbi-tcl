#!/usr/bin/env tclsh


set sbi_dir [file normalize [file join ~ .sbi]]
set src_dir [file join $sbi_dir srcs]
set build_dir [file join $sbi_dir build]
set inst_dir [file join $sbi_dir installed]
set rep_dir [file join $sbi_dir recipes]
file mkdir $src_dir
file mkdir $build_dir
file mkdir $rep_dir

proc p_usage {} {
	puts "$argv0 usage: \[--build] \[--import] <recipe-path>"
}

set import_rep ""
set build_rep ""
set rem_rep ""

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
		}
		--remove {
			incr i
			set rem_rep [lindex $argv $i]
		}
		default { error "Unrecognized arg $arg!" }
	}
}

proc get_pkg_dir {pkg_name_ver} {
	global inst_dir
	return [file join $inst_dir $pkg_name_ver]
}

if {[string length $import_rep] > 0} {
	# TODO: Change import name to reflect package name + version
	source $import_rep
	set short_name "[dict get $rep_info name]-[dict get $rep_info ver]"
	set rep_dest [file join $rep_dir $short_name.tcl]
	file copy -force $import_rep $rep_dest
}

if {[string length $rem_rep] > 0} {
	# TODO: Change import name to reflect package name + version
	if {[string compare $rem_rep "all"] == 0} {
		# Delete everything
		set all_folders [glob -directory $inst_dir *]
		foreach folder $all_folders {
			puts "Deleting $folder"
			file delete -force -- $folder
		}
	} else {
		set exp_dir [file join $inst_dir $rem_rep]
		if {[file isdirectory $exp_dir]} {
			puts "Removing $rem_rep"
			file delete -force -- $exp_dir
		} else {
			error "Package $rem_rep not found!"
		}
	}
}


proc build_recipe {rep_path} {
	global rep_dir
	set import_path [file join $rep_dir ${rep_path}.tcl]
	if {[file isfile $import_path]} {
		puts "Sourcing imported recipe $import_path"
		source $import_path
	} else {
		if {[file isfile $rep_path] == 0} {
			error "$rep_path Isn't a file (or doesn't exist)!. You may need to import the recipe."
		}
		# Build the recipe
		source $rep_path
	}
	# Assume data is in rep_info 
	puts "Recipie info:"
	dict for {k v} $rep_info {
		puts "    - $k=$v"
	}
	puts "\n"
	set short_name "[dict get $rep_info name]-[dict get $rep_info ver]"
	global inst_dir
	set exp_path [file join $inst_dir $short_name]
	if {[file isdirectory $exp_path]} {
		puts "$short_name is installed, skipping build"
		return
	}
	set srcs [dict get $rep_info srcs]
	global src_dir
	foreach src $srcs {
		set src_name [file tail $src]
		set save_path [file join $src_dir $src_name]
		if {[file exists $save_path] == 0} {
			puts "Downloading $src_name to $save_path"
			exec >&stdout curl -o $save_path $src
			puts "Downloaded $src_name to $save_path"
		}
	}

	global build_dir
	set tmp_build_dir [file join $build_dir $short_name]
	file delete -force -- $tmp_build_dir
	file mkdir $tmp_build_dir

	# Exctrace source to build dir
	foreach src $srcs {
		set src_name [file tail $src]
		set save_path [file join $src_dir $src_name]
		puts "Extracting $save_path to $tmp_build_dir"
		exec >&@stdout tar -xf $save_path -C $tmp_build_dir
	}

	# Configure the build
	global inst_dir
	set pkg_inst_dir [file join $inst_dir $short_name]
	file delete -force -- $pkg_inst_dir
	set cfg_dir [file join $tmp_build_dir [dict get $rep_info cd_dest]]
	if {[dict exists $rep_info build_needs]} {
		set b_needs [dict get $rep_info build_needs]
		foreach need $b_needs {
			set need_inst_dir [file join $inst_dir $need]
			if {[file isdirectory $need_inst_dir] == 0} {
				build_recipe $need
			}
		}
	}
	# This needs to go after other recipies are built, otherwise the variables could
	# carry into function calls that they didn't apply to.
	cd $cfg_dir
	set cfg_flags ""
	if {[dict exists $rep_info cfg_flags]} {
		set cfg_flags [dict get $rep_info cfg_flags]
		puts "Using cfg flags $cfg_flags"
	}
	# TODO: logging
	exec >&@stdout ./configure {*}$cfg_flags --prefix=$pkg_inst_dir

	# Make it
	exec >&@stdout make

	# Install it.
	exec >&@stdout make install
	# TODO: Delete the install dir if the install fails
	file delete -force -- $tmp_build_dir
}

if {[string length $build_rep] > 0} {
	build_recipe $build_rep
}
