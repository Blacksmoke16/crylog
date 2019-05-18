module Crylog
  abstract struct LogFormatter
    # Consumes a message and returns a formatted string.
    abstract def format(msg : Message) : String
  end
end
