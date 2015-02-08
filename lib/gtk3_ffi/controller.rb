module Gtk
  class Controller
    include GLib
    include GObject
    include Gtk

    def initialize
      @builder = gtk_builder_new
    end

    # Calls gtk_builder_add_from_file with the controller's builder
    # and the given file_name. After this call, objects defined in the
    # glade file can be retrieved with calls to `get_object`
    def build_ui(file_name)
      gtk_builder_add_from_file(@builder, file_name, FFI::MemoryPointer::NULL)
      connect_signals
    end

    # Calls gtk_builder_get_object with the controller's builder
    # and the given object name. This will retrieve the specified
    # object as identified by the given name from the glade files
    # built by calls to `build_ui`
    #
    # Returns the object as an FFI::Pointer
    def get_object(name)
      gtk_builder_get_object(@builder, name)
    end

    def connect_signals
      connect_func = proc do |builder, object, signal_name, handler_name, connect_obj, flags, user_data|
        handler = self.method(handler_name) rescue nil
        unless handler
          puts "WARNING: Handler method '#{handler_name}' not defined on controller"
          next
        end

        handler_func = FFI::Function.new(:void, []) do
          handler.call
        end

        g_signal_connect_data(object, signal_name, handler_func, FFI::MemoryPointer::NULL, FFI::MemoryPointer::NULL, 0)
      end

      gtk_builder_connect_signals_full(@builder, connect_func, FFI::MemoryPointer::NULL)
    end
  end
end
