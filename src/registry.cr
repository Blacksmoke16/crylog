module Crylog
  # Stores the loggers registered with `Crylog`.
  struct Registry
    # Hash of registered loggers.
    class_getter loggers : Hash(String, Crylog::Logger) = Hash(String, Crylog::Logger).new

    # Yields a new `Crylog::Logger` with *channel* yields to *&block*.  Then registers the resulting `Crylog::Logger`.
    def self.register(channel : String, &block : Crylog::Logger -> Crylog::Logger)
      @@loggers[channel] = yield Crylog::Logger.new channel
    end

    # Clears the registry.
    def self.clear : Hash(String, Crylog::Logger)
      @@loggers.clear
    end

    # Closes all handlers on each logger.
    def self.close
      @@loggers.values.each &.close
      @@loggers.clear
    end
  end
end
