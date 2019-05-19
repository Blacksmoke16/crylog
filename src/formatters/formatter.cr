# Controls how a `Crylog::Message` gets serialized when handled.
module Crylog::Formatters
  abstract struct LogFormatter
    # Consumes a *message* and returns a formatted string representation of it.
    abstract def format(message : Message) : String
  end
end
