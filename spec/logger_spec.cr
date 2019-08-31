require "./spec_helper"
require "colorize"

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
      handler.messages.first.context?.should be_false
    end

    it "should log a colorized string" do
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug "I'm red".colorize :red

      handler.messages.first.message.should eq "\e[31mI'm red\e[0m"
      handler.messages.first.context?.should be_false
    end

    it "should log nil" do
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug nil

      handler.messages.first.message.should eq ""
      handler.messages.first.context?.should be_false
    end

    it "should stringify whatever is logged" do
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug 123

      handler.messages.first.message.should eq "123"
      handler.messages.first.context?.should be_false
    end

    it "should log with context" do
      Crylog::Logger.new("test")
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug "foo", Crylog::LogContext{"key" => "value"}

      handler.messages.first.message.should eq "foo"
      handler.messages.first.context.should eq Crylog::LogContext{"key" => "value"}
    end

    it "should log with a block" do
      Crylog::Logger.new("test")
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug { "foo" }
      logger.debug { {"bar", nil} }

      handler.messages.first.message.should eq "foo"
      handler.messages.first.context?.should be_false
      handler.messages.[1].message.should eq "bar"
      handler.messages.[1].context?.should be_false
    end

    it "should log with a block and a context" do
      Crylog::Logger.new("test")
      handler = Crylog::Handlers::TestHandler.new
      logger = Crylog::Logger.new("test").handlers = [handler] of Crylog::Handlers::LogHandler
      logger.debug { {"foo", Crylog::LogContext{"key" => "value"}} }

      handler.messages.first.message.should eq "foo"
      handler.messages.first.context.should eq Crylog::LogContext{"key" => "value"}
    end
  end
end
