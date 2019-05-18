module Crylog
  # Represents a logged message and its metadata.
  class Message
    # The message that was logged.
    getter message : String

    # The severity level of the logged message.
    getter severity : Severity

    # What channel the messaged was logged to.
    getter channel : String

    # When the message was logged.
    getter datetime : Time

    # Any extra context added by `Crylog::Processor`s.
    property extra : Hash(String, Context)

    # Any extra context added when the message was logged.
    getter context : Hash(String, Context)

    # Represents the formatted version of this message.
    property formatted : String = ""

    def initialize(@message : String, @context : Hash(String, Context), @severity : Crylog::Severity, @channel : String, @datetime : Time, @extra : Hash(String, Context)); end
  end
end
