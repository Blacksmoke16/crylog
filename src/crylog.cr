require "json"

require "./formatters/*"
require "./handlers/*"
require "./logger"
require "./message"
require "./processors/*"
require "./registry"

# A flexible logging framework for Crystal.
module Crylog
  # The possible types the value could be in `Crylog::Message#context` and `Crylog::Message#extra` hashes.
  alias Context = Nil | String | Int8 | Int16 | Int32 | Int64 | UInt8 | UInt16 | UInt32 | UInt64 | Float32 | Float64 | Bool | Hash(String, Crylog::Context) | Array(Crylog::Context)

  # :nodoc:
  alias MsgType = Tuple(String, Crylog::LogContext?) | String

  # Convenience alias for creating `Crylog::Message#context` and `Crylog::Message#extra` hashes.
  #
  # ```
  # message.extra["data"] = Crylog::LogContext{"key" => "value"}
  # ```
  alias LogContext = Hash(String, Crylog::Context)

  # The channel to use when no channel is supplied to `.logger`.
  class_property default_channel : String = "main"

  # Returns a `Crylog::Logger` for the provided *channel*.
  def self.logger(channel : String = Crylog.default_channel) : Crylog::Logger
    Registry.loggers[channel]? || raise "Requested '#{channel}' logger instance has not been registered."
  end

  # Configures `Crylog`.  Defines the logger instances.
  def self.configure(&block : Registry.class -> Nil) : Nil
    yield Registry
  end

  # Close all handlers upon exit.
  at_exit { Crylog::Registry.close }
end
