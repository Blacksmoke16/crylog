# A handler is a struct that handles the actual writing/sending of the logged message; such as a file, STDOUT, Sentry, Greylog etc.
module Crylog::Handlers
  # Base struct of all handlers.
  abstract struct LogHandler
  end
end
