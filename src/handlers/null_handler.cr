require "./handler"

module Crylog::Handlers
  # Discards all messages it is able to handle.
  struct NullHandler < Crylog::Handlers::LogHandler
    # Initializes a log handler that will handle any message with a severity greater than or equal to *severity*.
    def initialize(@severity : Crylog::Severity = Crylog::Severity::Debug); end

    # Determines if this handler is able to handle *message*.
    def handles?(message : Crylog::Message) : Bool
      message.severity >= @severity
    end

    # Throws away the given *message*.
    def handle(message : Crylog::Message) : Bool
      message.severity >= @severity
    end
  end
end
