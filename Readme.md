Very simple object orientation framework in a few lines of TCL code. 
===================================================================
This code has been written to simplify the handling of parameters in EDA tools, holding a limited number of values together with a few methods for calculations based on these numbers. Main aspect was portability together with minimizing possible side effects by overwriting existing functions like proc as needed for stooop. Classes are stored in as a variable containing the body in the tinyOO namespace and a proc with the name of class is created in the main namespace to construct an instance. This proc is called with the name of the instance to be created, which is implemented as a new namespace where the class code is evaluated into and where the constructor is called afterwards with all potential additional arguments. As such naming of instances is not handled automatically as well as there is no explicit implementation to deconstruct an instance. Make sure not to use existing procedure names as class names as well as not to use existing namespace names for instances.

``` tcl
source tinyOO.tcl

class Foo {
	proc constructor {self} {
		variable bar "Hello world"
	}

	proc hello args {
		variable bar
		puts $bar
	}
}

class Bar extends Foo {
	proc hello_name {name} {
		variable bar
		puts "${bar}, $name"
	}
}

% % % % % 
% Foo a   
% a::hello
Hello world
% Bar b
% b::hello
Hello world
% b::hello_name baz
Hello world, baz
% set a::class
::Foo
% set b::class
::Bar
```
