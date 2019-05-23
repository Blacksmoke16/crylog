require "../spec_helper"

describe Crylog::Processors::GitProcessor do
  describe "#call" do
    it "should add git information to the message" do
      message = create_message

      Crylog::Processors::GitProcessor.new.call message

      message.extra.has_key?("git").should be_true
      git_info = message.extra["git"].as(Hash)
      git_info.has_key?("branch").should be_true
      git_info["branch"].should be_a String
      git_info.has_key?("commit").should be_true
      git_info["commit"].should be_a String
    end
  end
end
