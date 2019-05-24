require "../spec_helper"

TIME_REGEX = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{9}Z/

describe Crylog::Processors::GitProcessor do
  describe "#call" do
    describe "with line breaks not allowed" do
      describe "without context/extra" do
        it "should render the string correctly" do
          Crylog::Formatters::LineFormatter.new.call(create_message(message: "this is a example\nmessage\r\nwith line\rbreaks")).should match /\[#{TIME_REGEX}\] test.DEBUG: this is a example message with line breaks/
        end
      end

      describe "with context" do
        it "should render the string correctly" do
          Crylog::Formatters::LineFormatter.new.call(create_message(message: "this is a example\nmessage\r\nwith line\rbreaks", context: Crylog::LogContext{"key" => 12})).should match /\[#{TIME_REGEX}\] test.DEBUG: this is a example message with line breaks {"key":12}/
        end
      end

      describe "with extra" do
        it "should render the string correctly" do
          Crylog::Formatters::LineFormatter.new.call(create_message(message: "this is a example\nmessage\r\nwith line\rbreaks", extra: Crylog::LogContext{"key" => "value"})).should match /\[#{TIME_REGEX}\] test.DEBUG: this is a example message with line breaks {"key":"value"}/
        end
      end

      describe "with both context and extra" do
        it "should render the string correctly" do
          Crylog::Formatters::LineFormatter.new.call(create_message(message: "this is a example\nmessage\r\nwith line\rbreaks", context: Crylog::LogContext{"key" => 12}, extra: Crylog::LogContext{"key" => "value"})).should match /\[#{TIME_REGEX}\] test.DEBUG: this is a example message with line breaks {"key":12} {"key":"value"}/
        end
      end
    end

    describe "with line breaks not allowed" do
      it "should render the string correctly" do
        Crylog::Formatters::LineFormatter.new(true).call(create_message(message: "this is a example\nmessage\r\nwith line\rbreaks")).should match /\[#{TIME_REGEX}\] test.DEBUG: this is a example\nmessage\r\nwith line\rbreaks/
      end
    end
  end
end
