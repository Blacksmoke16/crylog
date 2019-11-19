require "./spec_helper"

describe Crylog::CrylogLogger do
  it "is compatable with a ::Logger type" do
    handler = Crylog::Handlers::TestHandler.new

    Crylog::Registry.register "main" do |logger|
      logger.handlers = [handler] of Crylog::Handlers::LogHandler
    end

    logger : ::Logger = Crylog::CrylogLogger.new

    logger.debug "foo"

    handler.messages.first.message.should eq "foo"
    handler.messages.first.context?.should be_false
  end

  it "is compatable ::Logger block methods" do
    handler = Crylog::Handlers::TestHandler.new

    Crylog::Registry.register "main" do |logger|
      logger.handlers = [handler] of Crylog::Handlers::LogHandler
    end

    logger : ::Logger = Crylog::CrylogLogger.new

    logger.info do
      "bar"
    end

    handler.messages.first.message.should eq "bar"
    handler.messages.first.context?.should be_false
  end

  it "works when mixing ::Logger and CrylogLogger types" do
    handler = Crylog::Handlers::TestHandler.new

    Crylog::Registry.register "main" do |logger|
      logger.handlers = [handler] of Crylog::Handlers::LogHandler
    end

    logger : ::Logger = Crylog::CrylogLogger.new

    logger.debug "foo"

    logger.info do
      "bar"
    end

    handler.messages[0].message.should eq "foo"
    handler.messages[0].context?.should be_false

    handler.messages[1].message.should eq "bar"
    handler.messages[1].context?.should be_false

    io = IO::Memory.new

    logger = ::Logger.new io

    logger.warn "baz"

    io.to_s.should match /.*WARN -- : baz\n/
  end
end
