# Controls how a `Crylog::Message` gets serialized when handled.
module Crylog::Formatters
  # The possible types of a Formatter.
  alias LogFormatters = Crylog::Formatters::LogFormatter | Proc(Crylog::Message, String)

  abstract struct LogFormatter
    # Consumes a *message* and returns a formatted string representation of it.
    abstract def call(message : Message) : String
  end
end
