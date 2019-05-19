module Crylog
  # Logging levels as defined by [RFC 5424](http://tools.ietf.org/html/rfc5424).
  enum Severity
    # Detailed debugging information.
    Debug = 100

    # Interesting events.
    #
    # Examples: User logs in, SQL logs.
    Info = 200

    # Uncommon events.
    Notice = 250

    # Exceptional occurrences that are not errors.
    #
    # Examples: Use of deprecated APIs, poor use of an API, undesirable things that are not necessarily wrong.
    Warning = 300

    # Runtime errors.
    Error = 400

    # Critical conditions.
    #
    # Example: Application component unavailable, unexpected exception.
    Critical = 500

    # Action must be taken immediately.
    #
    # Example: Entire website down, database unavailable, etc.
    # This should trigger the SMS alerts and wake you up.
    Alert = 550

    # Urgent alert.
    Emergency = 600
  end

  # A logger instance.
  struct Logger
    # The handlers that will do something with each message.
    getter handlers : Array(LogHandler) = [] of LogHandler

    # Processors that can add additional information to each message.
    getter processors : Array(LogProcessors) = [] of LogProcessors

    # Sets the handlers to use for `self`.
    def handlers=(handlers : Array(LogHandler)) : self
      @handlers = handlers
      self
    end

    # Sets the processors to use for `self`.
    def processors=(processors : Array(LogProcessors)) : self
      @processors = processors
      self
    end

    # Creates a new `Logger` with the provided *channel*.
    def initialize(@channel : String); end

    {% for name in Severity.constants %}
      # Logs the *message* and optionally *context*.
      def {{name.id.downcase}}(message : String, context : LogContext = Hash(String, Context).new) : Nil
        log Severity::{{name.id}}, message, context
      end
    {% end %}

    # :nodoc:
    private def log(severity : Severity, message : String, context : LogContext = Hash(String, Context).new) : Nil
      msg = Message.new message, context, severity, @channel, Time.utc, Hash(String, Context).new

      # Return early if no handlers handle this message.
      return false if @handlers.none?(&.handles?(msg))

      # Run the loggers's processors
      @processors.each &.call msg

      # Run the logger's handlers.  Returning early is *bubble* was set to false.
      @handlers.each do |handler|
        break if handler.handle msg
      end
    end
  end
end
