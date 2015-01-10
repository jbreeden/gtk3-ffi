require 'ffi'
require 'pry'
require_relative '../../lib/gtk3_ffi'

Gtk.gtk_init(FFI::MemoryPointer::NULL,FFI::MemoryPointer::NULL)
builder = Gtk.gtk_builder_new
Gtk.gtk_builder_add_from_file(builder, "#{File.dirname(__FILE__)}/ui.glade", FFI::MemoryPointer::NULL)

window = Gtk.gtk_builder_get_object(builder, "window1")
button = Gtk.gtk_builder_get_object(builder, "button1")

on_click = FFI::Function.new(:void, [:pointer, :pointer]) do
  puts "click event caught"
end

on_destroy = FFI::Function.new(:void, [:pointer, :pointer]) do
  Gtk.gtk_main_quit
end

binding.pry

GObject.g_signal_connect_data(button, "clicked", on_click, FFI::Pointer::NULL, FFI::Pointer::NULL, 0)
GObject.g_signal_connect_data(window, "destroy-event", on_destroy, FFI::Pointer::NULL, FFI::Pointer::NULL, 0)
Gtk.gtk_widget_show (window)
Gtk.gtk_main
puts "finished"
