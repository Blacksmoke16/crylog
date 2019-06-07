require "spec"
require "../src/crylog"

TIME_REGEX      = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{9}Z/
JSON_TIME_REGEX = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/

Spec.before_each { Crylog::Registry.close }

# Creates and returns a `Crylog::Message` with the provided options.
def create_message(
  *,
  message : String? = "",
  context : Hash(String, Crylog::Context) = Hash(String, Crylog::Context).new,
  severity : Crylog::Severity = Crylog::Severity::Debug,
  extra : Hash(String, Crylog::Context) = Hash(String, Crylog::Context).new
) : Crylog::Message
  Crylog::Message.new message, context, severity, "test", Time.utc, extra
end
