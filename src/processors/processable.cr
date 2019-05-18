# Represents handlers that can have handler specific processors.
module Crylog::Processable
  # The formatter to use, defaults to `LineFormatter`.
  getter processors : Array(LogProcessor) = [] of LogProcessor
end
