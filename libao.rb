module Libao
  extend FFI::Library

  begin
    ffi_lib ['ao', 'libao.so.1']
  rescue LoadError => e
    puts "Failed to load libao!"
    raise
  end

  # Constants
  AO_TYPE_LIVE   = 1
  AO_TYPE_FILE   = 2

  AO_ENODRIVER   = 1
  AO_ENOTFILE    = 2
  AO_ENOTLIVE    = 3
  AO_EBADOPTION  = 4
  AO_EOPENDEVICE = 5
  AO_EOPENFILE   = 6
  AO_EFILEEXISTS = 7
  AO_EBADFORMAT  = 8

  AO_EFAIL       = 100

  AO_FMT_LITTLE  = 1
  AO_FMT_BIG     = 2
  AO_FMT_NATIVE  = 4

  # This is the struct that contains information
  # about a device.
  class AoInfo < FFI::Struct
    layout  :type, :int,
            :name, :string,
            :short_name, :string,
            :comment, :string,
            :preferred_byte_format, :int,
            :priority, :int,
            :options, :pointer,
            :option_count, :int
  end

  # This is the struct for options, use append option
  # to set this
  class AoOption < FFI::Struct
    layout  :key, :string,
            :value, :string,
            :next, :pointer
  end

  # This is the struct containing information about the
  # sound to be played.
  class AoSampleFormat < FFI::Struct
    layout  :bits, :int,        # How many bits per sample?
            :rate, :int,        # The sample rate, in kHz
            :channels, :int,    # Number of channels
            :byte_format, :int, # The format, see constants aboce
            :matrix, :pointer   # Channel arrangement, see libao documentation
  end

  # Library Setup/Teardown
  attach_function :ao_initialize, [], :void
  attach_function :ao_shutdown, [], :void

  # Device Setup/Playback/Teardown
  attach_function :ao_append_option, [:pointer, :string, :string], :int
  attach_function :ao_append_global_option, [:string, :string], :int
  attach_function :ao_free_options, [:pointer], :void
  attach_function :ao_open_live, [:int, :pointer, :pointer], :pointer
  attach_function :ao_open_file, [:int, :string, :int, :pointer, :pointer], :pointer
  attach_function :ao_play, [:pointer, :pointer, :uint32], :int
  attach_function :ao_close, [:pointer], :int

  # Driver Information
  attach_function :ao_driver_id, [:string], :int
  attach_function :ao_default_driver_id, [], :int
  attach_function :ao_driver_info, [:int], :pointer
  attach_function :ao_driver_info_list, [:pointer], :pointer
  # This function is missing from OS X?
  # attach_function :ao_file_extension, [:int], :string

  # Miscellaneous
  attach_function :ao_is_big_endian, [], :int
end
