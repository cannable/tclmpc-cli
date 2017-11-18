#!/usr/bin/env tclsh

# Adjust auto_path to point to tclmpc, as if it weren't installed
lappend auto_path [file normalize [file join .. tclmpc]]

source tclmpc-cli.tcl
