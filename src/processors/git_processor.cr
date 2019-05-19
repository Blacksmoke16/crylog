require "./processor"

module Crylog
  struct GitProcessor < LogProcessor
    def call(msg : Message) : Nil
      current_branch = `git branch -v --no-abbrev`
      git_info = current_branch.match /^\* (.+?)\s+([a-f0-9]{40})(?:\s|$)/

      return unless git_info

      msg.extra["git"] = Crylog::LogContext{"branch" => git_info[1]?, "commit" => git_info[2]?}
    end
  end
end
