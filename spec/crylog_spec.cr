require "./spec_helper"

describe Crylog do
  describe "it is able to register and retrieve loggers" do
    it "should return the logger with the default name" do
      Crylog.configure do |registry|
        registry.register "main" do |logger|
          logger
        end
      end

      Crylog.logger.channel.should eq "main"
    end

    it "should return the logger with the provided name" do
      Crylog.configure do |registry|
        registry.register "worker" do |logger|
          logger
        end
      end

      Crylog.logger("worker").channel.should eq "worker"
    end

    it "should raise an exception for a logger that doesn't exist" do
      expect_raises Exception, "Requested 'foo' logger instance has not been registered." { Crylog.logger "foo" }
    end
  end
end
