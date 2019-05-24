# Represents handlers that can have handler specific processors.
module Crylog::Processors::Processable
  # The processors specific to a given handler.
  getter processors : Array(Crylog::Processors::LogProcessors) = [] of Crylog::Processors::LogProcessors
end
