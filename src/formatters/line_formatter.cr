module Crylog::Formatters
  # Formats the message to fit on a single line.
  struct LineFormatter < Crylog::Formatters::LogFormatter
    # Whether line breaks within a message should be stripped out.
    property allow_line_breaks : Bool = false

    # Instantiates `self`, stripping out out line breaks unless *allow_line_breaks*.
    def initialize(@allow_line_breaks : Bool = false); end

    # Consumes a *message* and returns a formatted string representation of it.
    def call(message : Crylog::Message) : String
      sdatetime = message.datetime.to_rfc3339
      schannel = message.channel
      sseverity = message.severity.to_s
      smessage = message.message? ? replace_line_breaks(message.message) : nil
      scontext = message.context? ? message.context.to_json : nil
      sextra = message.extra? ? message.extra.to_json : nil
      strlen = 10 + sdatetime.bytesize + schannel.bytesize + sseverity.bytesize + (smessage.try &.bytesize || 0) + (scontext.try &.bytesize || 0) + (sextra.try &.bytesize || 0)

      String.build(strlen) do |str|
        str << '[' << sdatetime << ']' << ' '
        str << schannel << '.' << sseverity << ':'
        str << ' ' << smessage if smessage
        str << ' ' << scontext if scontext
        str << ' ' << sextra if sextra
      end
    end

    # Replaces line breaks with spaces if *@allow_line_breaks* is false.
    protected def replace_line_breaks(message : String) : String
      @allow_line_breaks ? message : message.gsub("\r\n", ' ').gsub(/[\r\n]/, ' ').strip
    end
  end
end
