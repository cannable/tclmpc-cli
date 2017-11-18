#! /usr/bin/env tclsh

# tclmpc-cli.tcl --
#
#     Provides a simple CLI wrapper around tclmpc.
# 
# Copyright 2017 C. Annable
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package require tclmpc 0.1


# printUsage --
#
#           Prints usage info
#
# Arguments:
#           none
#
# Results:
#           Prints usage message to stdout
#
proc printUsage {} {
    puts {Usage: tclmpc-cli [-server localhost] [-port 6600] -- <command> [<args>]}
    puts "\ntclmpc-cli - Simple CLI wrapper around tclmpc.\n"
    puts "Some commands available:"

    puts {
        ==== Playback ====
        next
        pause [on|off]
        play songpos
        prev
        seek s
        stop
        toggle

        ==== Configuration ===
        config consume [on|off]
        config crossfade s
        config random [on|off]
        config repeat [on|off]
        config replaygain state
        config setvol vol
        config single [on|off]

        ==== Queue ===
        queue add uri
        queue clear
        queue delete pos
        queue deleteid id
        queue info
        queue insert uri pos
        queue shuffle

        ==== Info ===
        info currentsong
        info decoders
        info replaygain
        info rights
        info stats
        info status

        ==== Is ===
        is playing
        is stopped

        ==== DB ===
        db find args
        db list args 
        db search args 
        db update args

        ==== Outputs ===
        output disable id
        output enable id
        output toggle id
        output list

        ==== Playlists ===
        playlist allInfo
        playlist append name
        playlist clear name
        playlist exists name
        playlist info name
        playlist list
        playlist load name
        playlist rename name newName
        playlist rm name
        playlist save name
    }
}

# Set defaults
array set cfg {
    -server localhost
    -port 6600
}

# No arguments, print usage info
if {$argc == 0} {
    printUsage
    exit
}

# Get arguments

# Search for --
set idx [lsearch -exact $argv --]

if {$idx >= 0 } {
    # The invoker put a -- in the arguments. Thank you!

    set arguments [lrange $argv 0 $idx-1]
    set cmd [lrange $argv $idx+1 end]

    # Consider it an error if we got an odd number of arguments
    if {[llength $arguments] % 2} {
        printUsage
    }
} else {
    # This part is sketchy, try to figure out where the commands start

    set idx 4
    if {![string match "-*" [lindex $argv 0]]} {
        set idx 0
    } elseif {![string match "-*" [lindex $argv 2]]} {
        set idx 2
    }

    set arguments [lrange $argv 0 $idx-1]
    set cmd [lrange $argv $idx end]
}

# Clobber our default arguments
array set cfg $arguments

mpd connect $cfg(-server) $cfg(-port)
puts "[mpd {*}$::argv]"
mpd disconnect
