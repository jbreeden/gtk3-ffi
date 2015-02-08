gtk3-ffi (Experimental)
=======================

Ruby FFI bindings to gtk3, generated with ffi_gen. After experimenting with JRuby + JavaFX (too slow), wxWidgets + CRuby 
(too much C++), this is my current best-guess for a GUI development story with Ruby.

The hope is that by utilizing ffi_gen, the burden of maintaining the bindings with future GTK releases will be all
but eliminated. However, the bindings generated are a 1-to-1 replica of the GTK C API in Ruby, requiring some knowledge
of FFI to use effectively. This ensures that full access to GTK functionality is possible, but isn't very Ruby. To
alleviate this, some wrappers are provided over common functionality (such as creating a controller as a Ruby Class that
automatically binds event handlers to glade UI files).
