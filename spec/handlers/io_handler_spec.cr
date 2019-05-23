require "../spec_helper"

describe Crylog::Handlers::IOHandler do
  describe "#write" do
    it "should write to the provided IO" do
      io = IO::Memory.new
      handler = Crylog::Handlers::IOHandler.new io
      handler.handle create_message(message: "Some message")
      io.to_s.should match /.*test.DEBUG: Some message.*/
    end

    it "should write to a file" do
      file = File.tempfile("log.out")
      handler = Crylog::Handlers::IOHandler.new file
      handler.handle create_message(message: "Some message")
      File.read(file.path).should match /.*test.DEBUG: Some message.*/
      file.delete
    end
  end

  describe "#close" do
    it "be able to close the IO" do
      io = IO::Memory.new
      handler = Crylog::Handlers::IOHandler.new(io).close
      io.closed?.should be_true
      io.close.should be_true
    end
  end
end
