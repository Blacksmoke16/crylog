# Represents handlers that can have custom formatters.
module Crylog::Formattable
  # The formatter to use, defaults to `LineFormatter`.
  setter formatter : LogFormatter? = nil

  def formatter : LogFormatter
    (f = @formatter) ? f : default_formatter
  end

  # Can be overridden to use a different formatter for a handler.
  protected def default_formatter : LogFormatter
    LineFormatter.new
  end
end
