require "logger"
require "./logger"

# Compatibility class to support using `Crylog` with the `::Logger` type.
#
# Defines `Crylog::Logger` logging methods as well as maps `::Logger::Severity` methods to `Crylog::Severity` methods.
#
# ```
# Crylog.configure do |registry|
#   registry.register "main" do |logger|
#     logger.handlers = [
#       Crylog::Handlers::IOHandler.new STDOUT,
#     ] of Crylog::Handlers::LogHandler
#   end
# end
#
# one : ::Logger = Logger.new STDOUT
# two : ::Logger = Crylog::CrylogLogger.new
#
# one.warn "FOO" # => W, [2019-10-15 19:17:26 -04:00 #19986]  WARN -- : FOO
# two.warn "FOO" # => [2019-10-15T23:17:26.042287000Z] main.WARNING: FOO
# ```
class Crylog::CrylogLogger < ::Logger
  @logger : Crylog::Logger

  # Forward other methods to the underlying `Crylog::Logger` instance.
  forward_missing_to @logger

  # Use the `Crylog::Logger` with the provided *channel*.
  def initialize(channel : String = Crylog.default_channel)
    @logger = Crylog.logger channel
    super nil
  end

  # Define logging methods for `Crylog::Severity`.
  {% for name in Crylog::Severity.constants %}
    # Logs *message* and optionally *context* with `Crylog::Severity::{{name}}` severity.
    def {{name.id.downcase}}(message, context : Crylog::LogContext? = nil) : Nil
      @logger.{{name.id.downcase}} message, context
    end

    # Logs *message* and optionally *context* with `Crylog::Severity::{{name}}` severity.
    # Block is evaluated at least once due to https://github.com/crystal-lang/crystal/issues/8485.
    def {{name.id.downcase}}(& : -> Crylog::MsgType) : Nil
      @logger.{{name.id.downcase}} yield
    end
  {% end %}

  # Map `::Logger::Severity` methods to `Crylog::Severity` methods.
  {% for logger, crylog in {warn: "warning", fatal: "critical", unknown: "debug"} %}
    # Logs *message* and optionally *context* with `Crylog::Severity::{{crylog.camelcase.id}}` severity.
    def {{logger.id}}(message, context : Crylog::LogContext? = nil) : Nil
      @logger.{{crylog.id}} message, context
    end

    # Logs *message* and optionally *context* with `Crylog::Severity::{{crylog.camelcase.id}}` severity.
    # Block is evaluated at least once due to https://github.com/crystal-lang/crystal/issues/8485.
    def {{logger.id}}(& : -> Crylog::MsgType) : Nil
      @logger.{{crylog.id}} yield
    end
  {% end %}
end
