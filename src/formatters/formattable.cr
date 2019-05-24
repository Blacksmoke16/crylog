# Represents handlers that can have custom formatters.
module Crylog::Formatters::Formattable
  # The formatter to use, defaults to `Crylog::Formatters::LineFormatter`.
  setter formatter : Crylog::Formatters::LogFormatters? = nil

  # Returns the `Crylog::Formatters::LogFormatter` defined on `self`, or `#default_formatter` if none was set.
  def formatter : Crylog::Formatters::LogFormatters
    (f = @formatter) ? f : default_formatter
  end

  # Can be overridden to use a different formatter on a handler.
  protected def default_formatter : Crylog::Formatters::LogFormatters
    Crylog::Formatters::LineFormatter.new
  end
end
