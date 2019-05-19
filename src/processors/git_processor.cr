require "./processor"

module Crylog::Processor
  # Includes the Git branch and SHA commit hash in all logged messages.
  struct GitProcessor < Crylog::Processor::LogProcessor
    # Adds metadata to *message*.
    def call(message : Crylog::Message) : Nil
      current_branch = `git branch -v --no-abbrev`
      git_info = current_branch.match /^\* (.+?)\s+([a-f0-9]{40})(?:\s|$)/

      return unless git_info

      message.extra["git"] = Crylog::LogContext{"branch" => git_info[1]?, "commit" => git_info[2]?}
    end
  end
end
