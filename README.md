## Overview
This is a simple build from source package manager for Linux systems. It's designed to be used on top of your current Linux system.
It stores software and does all its work in `~/.sbi/`, which keeps software local to your user and out of system folders.
To simplify the built binaries, we prefer static linking where possible to remove a need to alter `LD_LIBRARY_PATH` for built binaries.

## Why TCL?
TCL is easier to build from source than python, has much more consistent syntax than bash, and has more file interface functions that lua.
It's not a great language, but it may be installed on your system already without you knowing it (for example, on RHEL systems `unbuffer` is a TCL script).
That makes this tool more accessible because it only requires TCL and `wget` to run.
