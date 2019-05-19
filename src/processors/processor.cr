# Adds metadata to each logged message.
module Crylog::Processor
  # The possible types of a `Crylog::Processor`.
  alias LogProcessors = Crylog::Processor::LogProcessor | Proc(Crylog::Message, Nil)

  abstract struct LogProcessor
    # Adds metadata to *message*.
    abstract def call(message : Crylog::Message) : Nil
  end
end
