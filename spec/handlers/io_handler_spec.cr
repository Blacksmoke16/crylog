require "../spec_helper"

describe Crylog::Handlers::IOHandler do
  describe "#write" do
    it "should write to the provided IO" do
      io = IO::Memory.new
      Crylog::Handlers::IOHandler.new(io).handle create_message(message: "Some message")
      io.to_s.should match /.*test.DEBUG: Some message.*/
    end

    it "should write to a file" do
      file = File.tempfile("log.out")
      Crylog::Handlers::IOHandler.new(file).handle create_message(message: "Some message")
      File.read(file.path).should match /.*test.DEBUG: Some message.*/
      file.delete
    end
  end

  describe "#close" do
    describe "with a file" do
      it "be able to close the IO" do
        file = File.tempfile("log.out")
        Crylog::Handlers::IOHandler.new(file).close
        file.closed?.should be_true
        file.delete
      end
    end

    describe "with a normal IO" do
      it "be able to close the IO" do
        io = IO::Memory.new
        Crylog::Handlers::IOHandler.new(io).close
        io.closed?.should be_false
      end
    end
  end
end
