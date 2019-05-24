require "../spec_helper"

describe Crylog::Handlers::NullHandler do
  describe "#handles?" do
    describe "of low severity" do
      it "should be true" do
        handler = Crylog::Handlers::NullHandler.new
        handler.handles?(create_message).should be_true
        handler.handles?(create_message(severity: Crylog::Severity::Info)).should be_true
        handler.handles?(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end

    describe "of mid severity" do
      it "should be true" do
        handler = Crylog::Handlers::NullHandler.new Crylog::Severity::Info
        handler.handles?(create_message).should be_false
        handler.handles?(create_message(severity: Crylog::Severity::Info)).should be_true
        handler.handles?(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end

    describe "of hight severity" do
      it "should be true" do
        handler = Crylog::Handlers::NullHandler.new Crylog::Severity::Emergency
        handler.handles?(create_message).should be_false
        handler.handles?(create_message(severity: Crylog::Severity::Info)).should be_false
        handler.handles?(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end
  end

  describe "#handle" do
    describe "of low severity" do
      it "should be true" do
        handler = Crylog::Handlers::NullHandler.new
        handler.handle(create_message).should be_true
        handler.handle(create_message(severity: Crylog::Severity::Info)).should be_true
        handler.handle(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end

    describe "of mid severity" do
      it "should be true" do
        handler = Crylog::Handlers::NullHandler.new Crylog::Severity::Info
        handler.handle(create_message).should be_false
        handler.handle(create_message(severity: Crylog::Severity::Info)).should be_true
        handler.handle(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end

    describe "of hight severity" do
      it "should be true" do
        handler = Crylog::Handlers::NullHandler.new Crylog::Severity::Emergency
        handler.handle(create_message).should be_false
        handler.handle(create_message(severity: Crylog::Severity::Info)).should be_false
        handler.handle(create_message(severity: Crylog::Severity::Emergency)).should be_true
      end
    end
  end
end
