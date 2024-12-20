#!/usr/bin/env tclsh

# This script cds around, so we need to record where we started when sourcing multiple files.
set start_dir [pwd]

proc p_usage {} {
	puts "$::argv0 usage:
    --build  <recipe-path>
        Builds a recipe and its not built dependencies
    --import <recipe-path>
        Imports a recipe for later use (like building another package)
    --sbi-dir <dest-folder>
        Changes the folder that sbi uses to build and install software to '<dest-folder>'
    --rebuild-deps
        Rebuild libraries that a package you're building needs (used with --build).
        This can rebuild packages twice if a package is specified twice in the needs 
        for needed recipies.
    --rebuild
        Rebuild the recipe you're building (used with --build)
    --rm-old-builds
        Delete the builds from the sbi build folder
    --delete <recipe-name>
        Delete imported recipie(s)
    --uninstall <recipe-name>
        Uninstall the installed files for <recipe-name>
        "
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
set rm_old_builds 0
set do_check 0

for {set i 0} {$i < $argc} {incr i} {
	set arg [lindex $argv $i]
	switch $arg {
        -h - 
        --help { 
            p_usage
        }
        --check { 
            set do_check 1
        }
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
		--rm-old-builds {
			set rm_old_builds 1
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

proc exec_stdout {exec_str} {
    exec >&@stdout {*}$exec_str
}

proc autotools_build {dir cfg_flags make_flags} {
    cd $dir
    puts "Using cfg flags: $cfg_flags"
    exec_stdout "./configure $cfg_flags"
    puts "Using make flags $make_flags"
    exec_stdout "make $make_flags"
}

if {$rm_old_builds > 0} {
    foreach b_dir [glob -directory $build_dir *] {
        puts "Deleting $b_dir"
        file delete -force -- $b_dir
    }
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

proc get_rep_short_name {rep_dict} {
	set short_name "[dict get $rep_dict plat]-[dict get $rep_dict name]-[dict get $rep_dict ver]"
	return $short_name
}

proc get_rep_path {rep_short_name} {
	global rep_dir
	return [file join $rep_dir $rep_short_name.tcl]
}

proc import_rep_file {f_import} {
	source $f_import
	set short_name [get_rep_short_name $rep_info]
	global rep_dir
	set rep_dest [get_rep_path $short_name]
	file copy -force $f_import $rep_dest
}

if {[llength $import_reps] > 0} {
	foreach rep $import_reps {
		import_rep_file $rep
		puts "Imported $rep"
	}
}

proc proc_exists {file name} {
    set search_f [open $file r]
    set f_text [read $search_f]
    close $search_f
    return [regexp "proc\\s+$name\\s+\{" $f_text]
}

if {[llength $rem_reps] > 0} {
	foreach r_rep $rem_reps {
		if {[string compare $r_rep "all"] == 0} {
			# Delete everything
			set all_folders [glob -nocomplain -directory $inst_dir *]
			foreach folder $all_folders {
				puts "Deleting $folder"
				file delete -force -- $folder
			}
		} else {
			set rep_file [get_rep_path $r_rep]
			set run_uninstall 0
			if {[file isfile $rep_file]} {
				source $rep_file
				set run_uninstall [proc_exists $rep_file uninstall]
			}
			set exp_dir [file join $inst_dir $r_rep]
			if {[file isdirectory $exp_dir]} {
				if {$run_uninstall} {
					set old_path $::env(PATH)
					set build_needs {}
					if {[dict exists $rep_info rm_needs]} {
						foreach need [dict get $rep_info rm_needs] {
							set need_bin_dir [file join $inst_dir $need bin]
							if {[file isdirectory $need_bin_dir]} {
								puts "Adding $need_bin_dir to PATH for uninstall"
								set env(PATH) "$need_bin_dir:$::env(PATH)"
							}
						}
					}
					uninstall $r_rep $exp_dir
					set env(PATH) $old_path
				}
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


# I just made up this hash function. It might not be any good.
proc str_to_hash {str} {
    set hash 2313
    set mult 7873
    set i 0
    foreach char [split $str ""] {
        incr i
        set bin_char [scan $char %c]
        set hash [expr $hash + $bin_char + $i]
        set hash [expr $hash * $mult]
        set hash [expr ($hash >> 7) ^ $hash]
        set hash [expr $hash & 0xfffffff]
    }
    return $hash
}

# This function returns a list of recipes that are built or that it built in the process of building something.
proc build_recipe {rep_path {rebuild 0} {rebuild_deps 0} {do_check 0}} {
	global rep_dir
	set src_path [file join $rep_dir ${rep_path}.tcl]
	if {[file isfile $src_path]} {
		puts "Sourcing imported recipe $src_path"
	} else {
		set src_path $rep_path
	}
	if {[file isfile $src_path] == 0} {
		error "$src_path Isn't a file (or doesn't exist)!. You may need to import the recipe."
	}
	source $src_path
	# Get the hash for the recipe
	set src_f [open $src_path r]
	set src_text [read $src_f]
	set src_hash [str_to_hash $src_text]
	close $src_f

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
		set ret [list $short_name]
		return $ret
	}

	if {[dict exists $rep_info srcs]} {
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
	}

	set built_pkgs [list]
	# Build needed libraries
	if {[dict exists $rep_info build_needs]} {
		set b_needs [dict get $rep_info build_needs]
		foreach need $b_needs {
			set need_inst_dir [file join $inst_dir $need]
			if {[file isdirectory $need_inst_dir] == 0} {
				set pkgs [build_recipe $need 0 0 $do_check]
				# Make sure we haven't built the package already if we're rebuilding deps
			} elseif {$rebuild_deps && [lsearch $built_pkgs $need] == -1} {
				set pkgs [build_recipe $need 1 1 $do_check]
			} else {
				set pkgs [list $need]
			}
            foreach pkg $pkgs {
                lappend built_pkgs $pkg
            }
		}
	}
	puts "Built/have $built_pkgs for $short_name"

	global build_dir
	set tmp_build_dir [file join $build_dir $short_name]
	# Clear out the builds completely before extracting
	# This keeps the build folder somewhat empty
	# Don't to this because we can't run concurrent builds
	file delete -force -- $tmp_build_dir
	file mkdir $tmp_build_dir

	if {[dict exists $rep_info srcs]} {
		# Excract source to build dir
		foreach src $srcs {
			set src_name [file tail $src]
			set save_path [file join $src_dir $src_name]
			puts "Extracting $save_path to $tmp_build_dir"
			set cmd "tar -xf $save_path -C $tmp_build_dir"
			if {[string match "*.zip" $save_path]} {
				set cmd "unzip $save_path -d $tmp_build_dir"
			}
			exec >&@stdout {*}$cmd
		}
	}

	# Make sure the functions are up to date.
	# sourcing other file could override them
	source $src_path

	set run_prep [proc_exists $src_path prepare]
	set run_build [proc_exists $src_path build]
	set run_install [proc_exists $src_path install]
	set run_check [proc_exists $src_path check]

	set pkg_inst_dir [file join $inst_dir $short_name]

	set old_env [array get ::env]
	# Add the build needs to the PATH
	puts "Built these pkgs $built_pkgs"
	foreach built_pkg $built_pkgs {
		set pkg_bin_dir [file join [get_pkg_dir $built_pkg] bin]
		if {[file isdirectory $pkg_bin_dir]} {
			puts "Adding $pkg_bin_dir to build PATH"
			set ::env(PATH) "$pkg_bin_dir:$::env(PATH)"
		} else {
			puts "$pkg_bin_dir does not exist"
		}
	}

	cd $tmp_build_dir
	if {$run_prep} {
		puts "Running prepare{}"
		prepare $pkg_name $pkg_inst_dir $tmp_build_dir
	}
	if {$run_build} {
		puts "Running build{}"
		build [dict get $rep_info name] [dict get $rep_info ver] $pkg_inst_dir $tmp_build_dir
	}
	if {$run_check && $do_check} {
		puts "Running check{}"
		check $short_name $pkg_inst_dir $tmp_build_dir
	}
	if {$run_install} {
		puts "Running install{}"
		install $short_name $pkg_inst_dir $tmp_build_dir
	}
	set inst_files [glob -nocomplain -directory $inst_dir *]]
	if {[llength $inst_files] == 0} {
		error "This recipe didn't install any files!"
	}

	# Dump the hash to see if the recipe's changed later.
	set hash_file [file join $pkg_inst_dir recipe-hash.txt]
	set hash_file [open $hash_file w]
	puts $hash_file $src_hash
	close $hash_file

	array set ::env $old_env

	# TODO: Delete the install dir if the install fails
	file delete -force -- $tmp_build_dir

	puts "\nInstalled $short_name"
	lappend built_pkgs $short_name
	return $built_pkgs
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
		build_recipe $b_rep $rebuild $rebuild_deps $do_check
	}
}
