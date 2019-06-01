require "./spec_helper"

describe Crylog::Logger do
  describe "#handlers" do
    it "should allow setting the handlers" do
      Crylog::Logger.new("test").handlers = [] of Crylog::Handlers::LogHandler
    end
  end

  describe "#processors" do
    it "should allow setting the processors" do
      Crylog::Logger.new("test").processors = [] of Crylog::Processors::LogProcessors
    end
  end

  describe "#log" do
    it "should log a string" do
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug "foo"

      handler.messages.first.message.should eq "foo"
      handler.messages.first.context.should eq Hash(String, Crylog::Context).new
    end

    it "should log nil" do
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug nil

      handler.messages.first.message.should eq ""
      handler.messages.first.context.should eq Hash(String, Crylog::Context).new
    end

    it "should log with context" do
      Crylog::Logger.new("test")
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug "foo", Crylog::LogContext{"key" => "value"}

      handler.messages.first.message.should eq "foo"
      handler.messages.first.context.should eq Crylog::LogContext{"key" => "value"}
    end
  end
end
