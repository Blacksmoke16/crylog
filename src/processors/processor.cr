module Crylog
  abstract struct LogProcessor
    abstract def process(msg : Message) : Nil
  end
end
