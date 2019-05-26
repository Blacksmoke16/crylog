require "./processing_handler"

module Crylog::Handlers
  # Allows writing to any IO; files, STDOUT, etc.
  struct IOHandler < Crylog::Handlers::ProcessingLogHandler
    # Writes the message to the given *io*.  If *lock*, and *io* is a file, locks the file before writing.
    def initialize(@io : IO, @lock : Bool = false, severity : Crylog::Severity = Crylog::Severity::Debug, bubble : Bool = true)
      super severity, bubble
    end

    # Writes *message* to the given *io*.
    def write(message : Crylog::Message)
      if (io = @io) && io.is_a?(File) && @lock
        io.flock_exclusive
      end

      @io.puts message.formatted

      if (io = @io) && io.is_a?(File) && @lock
        io.flock_unlock
      end

      @io.flush
    end

    # Closes *io* if it is a `File`.
    def close : Nil
      if (io = @io) && io.is_a?(File)
        io.closed? || io.close
      end
    end
  end
end
