# A handler is a struct that handles the actual writing/sending of the logged message; such as a file, STDOUT, Sentry, Greylog etc.
module Crylog::Handlers
  # Base struct of all handlers.
  abstract struct LogHandler
    # Called when the application exits.  Can be used to free up resources used within the handler.
    # Such as closing IOs, finalizing connections, etc.
    #
    # NOTE: Implementations have to be idempotent.  Loggers sharing the same instance of a handler would be closed more than once.
    def close; end
  end
end
