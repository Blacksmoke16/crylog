require "json"

module Crylog
  # Represents a logged message and its metadata.
  class Message
    include JSON::Serializable

    # The message that was logged.
    getter message : String

    # The severity level of the logged message.
    getter severity : Severity

    # What channel the messaged was logged to.
    getter channel : String

    # When the message was logged.
    getter datetime : Time

    # Any extra metadata added by a `Crylog::Processors::LogProcessor`.
    property extra : Hash(String, Crylog::Context)

    # Any extra metadata added when the message was logged.
    getter context : Hash(String, Crylog::Context)

    # Represents the formatted version of this message.
    @[JSON::Field(ignore: true)]
    property formatted : String = ""

    def initialize(@message : String, @context : Hash(String, Crylog::Context), @severity : Crylog::Severity, @channel : String, @datetime : Time, @extra : Hash(String, Crylog::Context)); end
  end
end
