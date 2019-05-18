require "json"

require "./formatters/*"
require "./handlers/*"
require "./logger"
require "./message"
require "./processors/*"
require "./registry"

module Crylog
  # :nodoc:
  alias Context = Nil | String | Int64 | Float64 | Bool | Hash(String, Context)
  alias LogContext = Hash(String, Context)

  # The channel to use when no channel is supplied to `.logger`.
  class_property default_channel : String = "main"

  # Returns a `Crylog::Logger` for the provided *channel*.
  def self.logger(channel : String = Crylog.default_channel)
    Registry.loggers[channel]? || raise "Requested '#{channel}' logger instance has not been registered."
  end

  # Configures `Crylog`.  Defines the logger channels.
  def self.configure(&block : Registry.class -> Nil)
    yield Registry
  end
end
