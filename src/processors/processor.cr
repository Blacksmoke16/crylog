# Adds metadata to each logged message.
module Crylog::Processors
  # The possible types of a Processor.
  alias LogProcessors = Crylog::Processors::LogProcessor | Proc(Crylog::Message, Nil)

  abstract struct LogProcessor
    # Adds metadata to *message*.
    abstract def call(message : Crylog::Message) : Nil
  end
end
