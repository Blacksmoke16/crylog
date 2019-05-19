module Crylog
  alias LogProcessors = LogProcessor | Proc(Crylog::Message, Nil)

  abstract struct LogProcessor
    abstract def call(msg : Message) : Nil
  end
end
