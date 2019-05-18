module Crylog
  abstract struct LogHandler
    protected def close; end
  end
end
