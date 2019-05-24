require "./spec_helper"

describe Crylog::Registry do
  describe "registering and clearing a logger" do
    it "should register a logger with the given channel" do
      Crylog::Registry.register "my_logger" do |logger|
        logger
      end

      Crylog::Registry.loggers.has_key?("my_logger").should be_true

      Crylog::Registry.clear
      Crylog::Registry.loggers.empty?.should be_true
    end
  end
end
