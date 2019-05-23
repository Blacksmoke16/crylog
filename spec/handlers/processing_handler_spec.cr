require "../spec_helper"

describe Crylog::Handlers::ProcessingLogHandler do
  # Test handle here since its an abstract
  describe "#handle" do
    describe "that does not handle the message" do
      it "should return false" do
        Crylog::Handlers::TestHandler.new(Crylog::Severity::Alert).handle(create_message).should be_false
      end
    end

    describe "that handles the message" do
      describe "that is set to bubble" do
        it "should return false" do
          handler = Crylog::Handlers::TestHandler.new
          handler.handle(create_message).should be_false
          handler.messages.size.should eq 1
        end
      end

      describe "that is set to not bubble" do
        it "should return false" do
          handler = Crylog::Handlers::TestHandler.new bubble: false
          handler.handle(create_message).should be_true
          handler.messages.size.should eq 1
        end
      end
    end
  end

  describe "#handles?" do
    describe "with a message of a lower severity" do
      it "should not handle the message" do
        Crylog::Handlers::TestHandler.new(Crylog::Severity::Alert).handles?(create_message).should be_false
      end
    end

    describe "with a message of a equal severity" do
      it "should handle the message" do
        Crylog::Handlers::TestHandler.new(Crylog::Severity::Alert).handles?(create_message(severity: Crylog::Severity::Alert)).should be_true
      end
    end

    describe "with a message of a higher severity" do
      it "should handle the message" do
        Crylog::Handlers::TestHandler.new(Crylog::Severity::Alert).handles?(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end
  end
end
