module Crylog
  # Stores the loggers registered with `Crylog`.
  struct Registry
    # Hash of registered loggers.
    class_getter loggers : Hash(String, Logger) = Hash(String, Logger).new

    # Registers
    def self.register(channel : String, &block : Logger -> Logger)
      @@loggers[channel] = yield Logger.new channel
    end

    # Clears the registry.
    def self.clear : Hash(String, Logger)
      @@loggers.clear
    end
  end
end
