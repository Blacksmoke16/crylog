require "./processing_handler"

module Crylog::Handlers
  # Keeps a record of all messages logged.  Most useful for testing.
  #
  # Used internaly to test `Crylog::Handlers::ProcessingLogHandler` and `Crylog::Handlers::AbstractLogProcessor`.
  struct TestHandler < Crylog::Handlers::ProcessingLogHandler
    # Array of messages handled by `self`.
    getter messages : Array(Crylog::Message) = [] of Crylog::Message

    # Adds *message* to the array of handled messages.
    def write(message : Crylog::Message)
      @messages << message
    end
  end
end
