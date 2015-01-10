$:.unshift "#{File.dirname(__FILE__)}/../ffi_gen/lib"
require 'ffi_gen'

$CLANG_HEADERS = "C:\\Program Files (x86)\\LLVM\\lib\\clang\\3.5.0\\include"

task :ffi_gen do
  gtk_include_dirs = ['./headers'] + Dir.glob('./headers/**/*').select { |f| Dir.exists? f }

  include_flags = ["-I#{$CLANG_HEADERS}"] + (gtk_include_dirs.map { |d| "-I#{d}"})

  modules = [
    {
      module_name: 'Gtk',
      output: './lib/gtk3_ffi/bindings/gtk.rb',
      cflags: ['-DGTK_COMPILATION'],
      ffi_lib: "libgtk-3-0.dll",
      headers: Dir.glob('./headers/include/gtk-3.0/gtk/*.h')
    },
    {
      module_name: 'GLib',
      output: './lib/gtk3_ffi/bindings/glib.rb',
      cflags: ['-DGLIB_COMPILATION'],
      ffi_lib: "libglib-2.0-0.dll",
      headers: Dir.glob('./headers/include/glib-2.0/glib/*.h')
    },
    {
      module_name: 'GObject',
      output: './lib/gtk3_ffi/bindings/gobject.rb',
      cflags: ['-DGOBJECT_COMPILATION', '-DGLIB_COMPILATION'],
      ffi_lib: "libgobject-2.0-0.dll",
      headers: Dir.glob('./headers/include/glib-2.0/gobject/*.h')
    },
    {
      module_name: 'Cairo',
      output: './lib/gtk3_ffi/bindings/cairo.rb',
      cflags: ['-DGOBJECT_COMPILATION', '-DGLIB_COMPILATION'],
      ffi_lib: "libcairo-2.dll",
      headers: Dir.glob('./headers/include/cairo/*.h')
    }
  ]

  modules.each do |mod|
    banner = "-- Generating: #{mod[:output]} --"
    banner_rule = (['-'] * banner.length).join

    banner = banner_rule + "\n" + banner + "\n" + banner_rule

    puts
    puts banner
    puts

    puts "Generating: #{mod[:output]}"
    FFIGen.generate(
      module_name: mod[:module_name],
      ffi_lib:     mod[:ffi_lib],
      cflags:      include_flags + mod[:cflags],
      headers:     mod[:headers],
      output:      mod[:output],
      skip_macro_functions: true
    )
  end
end

task :pry do
  require 'pry'
  $: << "./lib"
  require "gtk3_ffi"
  pry
end
