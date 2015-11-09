# OO framework in less then 40 lines of code :)
# Christoph Mueller 2015

# the namespace tinyOO is used for bookkeeping, in particular storing the bodys
namespace eval tinyOO {
    variable tinyOO_common_methods {
        proc serialize {} {
            variable self
            set commands {}
            foreach var [info vars ::${self}::*] { lappend commands "set $var \{[set $var]\}" }
            return $commands
        }
        # empty constructor
        proc constructor args {}
    }
    variable objects {}
    proc register {name body} { variable $name $body }
    proc register_object {name} { variable objects; lappend objects $name }
    proc serialize {} {
        variable objects
        set ser {}
        foreach obj $objects { lappend ser [${obj}::serialize]}
        return $ser
    }
}
# implement the class logic
# two steps:
# 1)    - get the bodies of all extended classes and store them before
#         the provided body in a variable within tinyoo::
#       
# 2) a proc with the name of the class is dynamically created to
#       - evaluate the stored bodies into the object namespace,
#         actual class body last.
#       - set the self pointer
#       - call the constructor

proc class args {
    set body {}
    set name [lindex $args 0]
    if {[llength $args]==2} {
        lappend body [lindex $args 1]
    } elseif {[llength $args] == 4 && [string match [lindex $args 1] extends]} {
        foreach extension [lindex $args 2] {
            foreach subbody [set ::tinyOO::$extension] {
                lappend body $subbody
            }
        }
        lappend body [lindex $args 3]
    }
    tinyOO::register $name $body
    proc $name args {
        set name [dict get [info frame 0] proc] ;# get the name of the current proccess (i.e. the class name)
        set n [lindex $args 0] ; # the first argument is supposed to be the name of the object
        #set args_ [lrange $args 1 end] 
        set body [set ::tinyOO::$name] ;# fetch the body
        namespace eval $n $tinyOO::tinyOO_common_methods; # create the namespace and add the common methods
        foreach b $body {
            namespace eval $n $b ;# initialize the classes
        }
        tinyOO::register_object $n
        set ${n}::self $n ;# set the self pointer
        set ${n}::class $name;
        ${n}::constructor {*}$args ;# call the constructor
    }
}
