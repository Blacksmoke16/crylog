require "./abstract_handler"
require "../processors/processable"
require "../formatters/formattable"

module Crylog::Handlers
  # Base struct implementing support for handler specific processors and formatter.
  #
  # Most handlers can inherit from this and implement `#write`.
  abstract struct ProcessingLogHandler < Crylog::Handlers::AbstractLogHandler
    include Crylog::Formatters::Formattable
    include Crylog::Processors::Processable

    # Writes *message* down to the log of the implementing handler.
    protected abstract def write(message : Crylog::Message) : Nil

    # Handles a logged message.
    #
    # Responsible for returning early if `self` should not handle *message*.
    # Runs `self`'s processors, formats, then writes *message*.
    def handle(message : Crylog::Message) : Bool
      # Return if this `self` doesn't handle *message*.
      return false unless self.handles? message

      # Run `self`'s processors
      @processors.each &.call message

      # Call the formatter to format *message*.
      message.formatted = formatter.call message

      # write the message
      write message

      !@bubble
    end
  end
end
