require "./processing_handler"

module Crylog
  # Allows writing to any IO; files, STDOUT, etc.
  struct IOHandler < ProcessingLogHandler
    # Writes the message to the given *io*.  If *lock*, and *io* is a file, locks the file before writing.
    def initialize(@io : IO, @lock : Bool = false, severity : Crylog::Severity = Crylog::Severity::Debug, bubble : Bool = true)
      super severity, bubble
    end

    def write(message : Message)
      if (io = @io) && io.is_a?(File) && @lock
        io.flock_exclusive
      end

      @io.puts message.formatted

      if (io = @io) && io.is_a?(File) && @lock
        io.flock_unlock
      end

      @io.flush
    end
  end
end
