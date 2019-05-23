require "../spec_helper"

describe Crylog::Handlers::NoopHandler do
  describe "#handles?" do
    describe "of any severity" do
      it "should be true" do
        handler = Crylog::Handlers::NoopHandler.new
        handler.handles?(create_message).should be_true
        handler.handles?(create_message(severity: Crylog::Severity::Info)).should be_true
        handler.handles?(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end
  end

  describe "#handle" do
    describe "of any severity" do
      it "should be true" do
        handler = Crylog::Handlers::NoopHandler.new
        handler.handle(create_message).should be_true
        handler.handle(create_message(severity: Crylog::Severity::Info)).should be_true
        handler.handle(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end
  end
end
