require "./handler"

module Crylog::Handlers
  # Handles any message but does nothing with it.
  struct NoopHandler < Crylog::Handlers::LogHandler
    # Handles any *message*.
    def handles?(message : Crylog::Message) : Bool
      true
    end

    # Does nothing with *message*.
    def handle(message : Crylog::Message) : Bool
      true
    end
  end
end
