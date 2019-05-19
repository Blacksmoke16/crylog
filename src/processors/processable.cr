# Represents handlers that can have handler specific processors.
module Crylog::Processor::Processable
  # The processors specific to a given handler.
  getter processors : Array(Crylog::Processor::LogProcessors) = [] of Crylog::Processor::LogProcessors
end
