# Represents handlers that can have handler specific processors.
module Crylog::Processable
  # The processors specific to a given handler.
  getter processors : Array(LogProcessors) = [] of LogProcessors
end
