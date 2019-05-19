# Controls how a `Crylog::Message` gets serialized when handled.
module Crylog::Formatters
  abstract struct LogFormatter
    # Consumes a *msg* and returns a formatted string representation of `Crylog::Message`.
    abstract def format(msg : Message) : String
  end
end
