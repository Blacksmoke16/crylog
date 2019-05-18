require "./handler"

module Crylog
  # Implements *severity* and *bubble* functionality.
  abstract struct AbstractLogHandler < LogHandler
    # The minimum severity that this handler should handle.
    property severity : Crylog::Severity = Crylog::Severity::Debug

    # Whether the message should be handled by the next handler.
    property bubble : Bool = true

    # Initializes a log handler that will handle any message with a severity greater than or equal to *severity*.
    #
    # *bubble* determines if messages should continue on to the next handler.
    def initialize(@severity : Crylog::Severity = Crylog::Severity::Debug, @bubble : Bool = true); end

    # Determines if this handler is able to handle *message*.
    def handles?(message : Crylog::Message) : Bool
      message.severity >= @severity
    end
  end
end
