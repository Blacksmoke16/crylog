require "../spec_helper"

describe Crylog::Formatters::JsonFormatter do
  describe "#call" do
    describe "defaults" do
      it "should output a JSON string" do
        Crylog::Formatters::JsonFormatter.new.call(create_message(message: "example message")).should match /{"message":"example message","severity":100,"channel":"test","datetime":"#{JSON_TIME_REGEX}","extra":{},"context":{}/
      end
    end

    describe "pretty print" do
      it "should output a pretty JSON string" do
        Crylog::Formatters::JsonFormatter.new(true).call(create_message(message: "example message")).should match /{\n  "message": "example message",\n  "severity": 100,\n  "channel": "test",\n  "datetime": "#{JSON_TIME_REGEX}",\n  "extra": {},\n  "context": {}\n}/
      end
    end
  end
end
