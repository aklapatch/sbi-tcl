#!/usr/bin/env tclsh

# This script cds around, so we need to record where we started when sourcing multiple files.
set start_dir [pwd]

proc p_usage {} {
	puts "$argv0 usage: \[--build] \[--import] <recipe-path>"
}

set import_reps {}
set build_reps {}
set rem_reps {} 
set del_reps {}
set rebuild 0
set rebuild_deps 0

# TODO: Make args take multiple entries
proc get_arg_list {arg_list start_i} {
	# Go until we hit an argument without -- starting it.
	# Return everything until that point
	set ret_l {}
	set arg_list_len [llength $arg_list]
	for {set i $start_i} {$i < $arg_list_len} {incr i} {
		set cmp_arg [lindex $arg_list $i]
		if {[string match "--*" $cmp_arg] == 1} {
			# We've found another argument. Stop here.
			break
		}
		lappend ret_l $cmp_arg
	}
	return $ret_l
}

set sbi_dir [file normalize [file join ~ .sbi]]

for {set i 0} {$i < $argc} {incr i} {
	set arg [lindex $argv $i]
	switch $arg {
		--build {
			incr i
			set build_reps [get_arg_list $argv $i]
			incr i [llength $build_reps]
			incr i -1
		}
        --sbi-dir {
            # Changes the folder where sbi stores installed packages and recipes
			incr i
			set sbi_dir [lindex $argv $i]
            set sbi_dir [file normalize $sbi_dir]
            puts "Setting the SBI storage folder to $sbi_dir"
        }
		--rebuild-deps {
			set rebuild_deps 1
		}
		--rebuild {
			set rebuild 1
		}
		--import {
			incr i
			set import_reps [get_arg_list $argv $i]
			incr i [llength $import_reps]
			incr i -1
		}
		--delete {
			incr i
			set del_reps [get_arg_list $argv $i]
			incr i [llength $del_reps]
			incr i -1
		}
		--uninstall {
			incr i
			set rem_reps [get_arg_list $argv $i]
			incr i [llength $rem_reps]
			incr i -1
		}
		default { error "Unrecognized arg $arg!" }
	}
}

set src_dir [file join $sbi_dir srcs]
set build_dir [file join $sbi_dir build]
set inst_dir [file join $sbi_dir installed]
set rep_dir [file join $sbi_dir recipes]
file mkdir $src_dir
file mkdir $build_dir
file mkdir $rep_dir

proc get_pkg_dir {pkg_name_ver} {
	global inst_dir
	return [file join $inst_dir $pkg_name_ver]
}

if {[llength $del_reps] > 0} {
    foreach rep $del_reps {
        if {[string compare $rep "all"] == 0} {
            set all_reps [glob -directory $rep_dir *.tcl]
                foreach rep $all_reps {
                    puts "Deleting $rep"
                    file delete $rep
                }
        } else {
            set del_rep_path [file join $rep_dir $rep.tcl]
            puts "Deleting $rep at $del_rep_path"
            file delete $del_rep_path
        }
    }
}

proc import_rep_file {f_import} {
	source $f_import
	set short_name "[dict get $rep_info plat]-[dict get $rep_info name]-[dict get $rep_info ver]"
	global rep_dir
	set rep_dest [file join $rep_dir $short_name.tcl]
	file copy -force $f_import $rep_dest
}

if {[llength $import_reps] > 0} {
	foreach rep $import_reps {
		import_rep_file $rep
	}
}

if {[llength $rem_reps] > 0} {
	foreach r_rep $rem_reps {
		if {[string compare $r_rep "all"] == 0} {
			# Delete everything
			set all_folders [glob -directory $inst_dir *]
			foreach folder $all_folders {
				puts "Deleting $folder"
				file delete -force -- $folder
			}
		} else {
			set exp_dir [file join $inst_dir $r_rep]
			if {[file isdirectory $exp_dir]} {
				puts "Removing $r_rep"
				file delete -force -- $exp_dir
			} else {
				error "Package $r_rep not found!"
			}
		}
	}
}

proc exec_log_cmd {cmd log_path} {
	set cmd_log [open $log_path w+]
	puts "Logging '$cmd' to $log_path"
	if {[catch {exec >&@$cmd_log {*}$cmd} ex_res]} {
		flush $cmd_log
		# Get the last 50 lines of the file
		seek $cmd_log 0 end
		set f_sz [tell $cmd_log]
		if {$f_sz == 0} {
			close $cmd_log
			error "Command '$cmd' failed. The log was empty"
		}

		set seek_off -1
		set newlines_seen 0
		set log_exc ""
		while {$newlines_seen < 30} {
			seek $cmd_log $seek_off end
			set char [read $cmd_log 1]
			set log_exc "${char}$log_exc"
			if {[string compare $char "\n"] == 0} {
				incr newlines_seen
			}
			# Bail if we've hit the end of the file
			set f_i [tell $cmd_log]
			if {$f_i == 1} {
				break
			}
			incr seek_off -1
		}
		close $cmd_log
		error "Command '$cmd' failed. A Log excerpt follows:\n$log_exc"

	}
	flush $cmd_log
	close $cmd_log
}


proc build_recipe {rep_path {rebuild 0} {rebuild_deps 0}} {
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
	set short_name "[dict get $rep_info plat]-[dict get $rep_info name]-[dict get $rep_info ver]"
	global inst_dir
	set exp_path [file join $inst_dir $short_name]
	if {[file isdirectory $exp_path] && $rebuild == 0} {
		puts "$short_name is installed, skipping build"
		return
	}
	set srcs [dict get $rep_info srcs]
	global src_dir
	foreach src $srcs {
		set src_name [file tail $src]
		set save_path [file join $src_dir $src_name]
		if {[file exists $save_path] == 0} {
			puts "Downloading $src_name ($src) to $save_path"
			exec >&@stdout wget -O $save_path $src
			puts "Downloaded $src_name to $save_path"
		}
	}

	global build_dir
	set tmp_build_dir [file join $build_dir $short_name]
	file delete -force -- $tmp_build_dir
	file mkdir $tmp_build_dir

	# Build needed libraries
	if {[dict exists $rep_info build_needs]} {
		set b_needs [dict get $rep_info build_needs]
		foreach need $b_needs {
			set need_inst_dir [file join $inst_dir $need]
			if {[file isdirectory $need_inst_dir] == 0} {
				build_recipe $need
			} elseif {$rebuild_deps} {
				build_recipe $need 1 1
			}
		}
	}

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
	if {[dict exists $rep_info cfg_proc]} {
		cd $tmp_build_dir
		set proc_name [dict get $rep_info cfg_proc]
		# Run the cofiguration proc
		# This proc should end in the dir where 'make' should be run
		# It will start in the temporary build folder
		puts "Running custom build function $proc_name"
		{*}$proc_name $short_name $pkg_inst_dir $tmp_build_dir
	} else {
		set cfg_prefix "."
		set cfg_dir [file join $tmp_build_dir [dict get $rep_info cd_dest]]
		if {[dict exists $rep_info cfg_type]} {
			set cfg_type [dict get $rep_info cfg_type]
			if {[string compare $cfg_type "at-new-dir"] == 0} {
				set new_cfg_dir [file join $tmp_build_dir "$short_name-build"]
				file mkdir $new_cfg_dir
				cd $new_cfg_dir
				set cfg_prefix "../[dict get $rep_info cd_dest]"
			
			} else {
				error "Bad configuration type '$cfg_type'!"
			}
		} else {
			cd $cfg_dir
		}
		# This needs to go after other recipies are built, otherwise the variables could
		# carry into function calls that they didn't apply to.
		set cfg_flags ""
		if {[dict exists $rep_info cfg_flags]} {
			set cfg_flags [dict get $rep_info cfg_flags]
			puts "Using cfg flags '$cfg_flags'"
		}
		set cfg_log [file join $tmp_build_dir cfg-log.txt]
		set cfg_cmd "$cfg_prefix/configure $cfg_flags --prefix=$pkg_inst_dir"
        if {[dict exists $rep_info cfg_cmd]} {
            set new_cfg_cmd [dict get $rep_info cfg_cmd]
            set cfg_cmd "$cfg_prefix/$new_cfg_cmd $cfg_flags --prefix=$pkg_inst_dir"
        }
		exec_log_cmd $cfg_cmd $cfg_log
	}

	set make_flags ""
	if {[dict exists $rep_info make_flags]} {
		set make_flags " [dict get $rep_info make_flags]"
		puts "Using make flags '$make_flags'"
	}
	# Make it
	set make_log [file join $tmp_build_dir make-log.txt]
	exec_log_cmd "make$make_flags" $make_log

	# TODO: move an existing install folder to a tmpdir, then delete it if the install fails.

	# Install it.
	set install_log [file join $tmp_build_dir install-log.txt]
	exec_log_cmd "make install" $install_log
	# TODO: Delete the install dir if the install fails
	file delete -force -- $tmp_build_dir

	puts "\nInstalled $short_name"
}

if {[llength $build_reps] > 0} {
	puts "Recipes to build: $build_reps"
	# Import the recipes first in case they depend on each other.
	set abs_build_reps {}
	foreach b_rep $build_reps {
		if {[file isfile $b_rep]} {
			# Only import the file if it's a file, not a recipe
			puts "Importing $b_rep"
			import_rep_file $b_rep

			# Normalize all the paths for recipe files.
			# This script cds around, so we need to do that otherwise
			# we'll lose track of the files.
			lappend abs_build_reps [file normalize $b_rep]
		} else {
			lappend abs_build_reps $b_rep
		}
	}
	foreach b_rep $abs_build_reps {
		puts "Building $b_rep"
		build_recipe $b_rep $rebuild $rebuild_deps
	}
}
