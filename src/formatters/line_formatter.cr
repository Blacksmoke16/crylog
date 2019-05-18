module Crylog
  # Formats the message to fit on a single line.
  struct LineFormatter < Crylog::LogFormatter
    # Whether line breaks within a message should be stripped out.
    property allow_line_breaks : Bool = false

    def initialize(@allow_line_breaks : Bool = false); end

    def format(msg : Message) : String
      String.build do |str|
        str << '[' << msg.datetime.to_rfc3339 << ']' << ' '
        str << msg.channel << '.' << msg.severity.to_s.upcase << ':' << ' '
        str << replace_line_breaks(msg.message)
        str << ' ' << msg.context.to_json unless msg.context.empty?
        str << ' ' << msg.extra.to_json unless msg.extra.empty?
      end
    end

    # Replaces line breaks with spaces if *@allow_line_breaks* is false.
    protected def replace_line_breaks(message : String) : String
      @allow_line_breaks ? message : message.gsub("\r\n", ' ').gsub(/[\r\n]/, ' ').strip
    end
  end
end
