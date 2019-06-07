module Crylog::Formatters
  # Formats the message as a JSON string.
  struct JsonFormatter < Crylog::Formatters::LogFormatter
    # Whether the JSON string should be pretty printed.
    property pretty_print : Bool = false

    # Instantiates `self`, outputting a pretty JSON string if *pretty_print*.
    def initialize(@pretty_print : Bool = false); end

    # Consumes a *message* and returns a formatted string representation of it.
    def call(message : Crylog::Message) : String
      @pretty_print ? message.to_pretty_json : message.to_json
    end
  end
end
