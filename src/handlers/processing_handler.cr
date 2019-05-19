require "./abstract_handler"
require "../processors/processable"
require "../formatters/formattable"

module Crylog
  # Base class implementing support for handler specific processors and formatter.
  #
  # Most handlers can inherit from this and implement #write.
  abstract struct ProcessingLogHandler < AbstractLogHandler
    include Formattable
    include Processable

    protected abstract def write(message : Message) : Nil

    def handle(message : Crylog::Message) : Bool
      # Return if this `self` doesn't handle *message*.
      return false unless self.handles? message

      # Run `self`'s procesors
      @processors.each &.call message

      # Call the formatter to format *message*.
      message.formatted = formatter.format message

      # write the message
      write message

      !@bubble
    end
  end
end
