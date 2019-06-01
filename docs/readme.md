# Documentation

Crylog is a flexible logging framework based on [Monolog](https://github.com/Seldaek/monolog).  It allows sending log messages to various locations such as files, external web services, and/or databases.

## Logger

The core class of `Crylog` is the `Crylog::Logger`.  A `Crylog::Logger` instance is what is used to log a message.  Each instance has a name, or channel, that is used to identify that specific instance.  

`Crylog::Logger` instances can be defined via the `Crylog.configure` method.

```crystal
require "crylog"

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::Handlers::IOHandler.new(STDOUT)
    ] of Crylog::Handlers::LogHandler
  end

  registry.register "worker" do |logger|
    logger.handlers = [
      Crylog::Handlers::IOHandler.new(STDOUT)
    ] of Crylog::Handlers::LogHandler
  end
end
```

This registers two `Crylog::Logger` instances with the name `main`, and `worker` each with a single handler that will print each message to standard out.  Each `Crylog::Logger` instance can have their own handlers, processors, and formatters.

A `Crylog::Logger` instance can be retrieved by using the `Crylog.logger(channel : String)` method.

```crystal
main_logger = Crylog.logger
main_logger.debug "Hello world!"
STDOUT # => [2019-05-19T00:44:02.387935000Z] main.DEBUG: Hello world!
```

Since we configured our logger to have a channel of `main`, we do not have to specify as a name, as `main` is the default channel name.  This can be changed via `Crylog.default_channel = "my_logger_name"`.  If you wish to retrieve an instance that is not the same as the default, simply give the method the name of the logger you want.

```crystal
worker_logger = Crylog.logger "worker"
worker_logger.debug "Hello from the worker!"
STDOUT # => [2019-05-19T00:45:05.558218000Z] worker.DEBUG: Hello from the worker!
```

The channel that logged each message is included within the logged message to allow for easy searching.

### Context

Extra data can be added to the logged message via the optional `context` argument on each severity's method.  This argument accepts a hash of data that will, by default, be JSON encoded into the logged message.  This however can be changed by using a custom handler formatter.

```crystal
main_logger = Crylog.logger
main_logger.info "User logged in", Crylog::LogContext{"user_id" => 17, "user_name" => "Fred"}
STDOUT # => [2019-05-19T00:49:57.315682000Z] main.INFO: User logged in {"user_id":17,"user_name":"Fred"}
```

## Handler

A handler is a struct that handles the actual writing/sending of the logged message; such as a file, STDOUT, Sentry, Greylog etc.  `Crylog` includes some basic handlers, but custom handlers can be defined as well.  By default, every log message will be handled by all handlers in the logger's array.  However, this can be fine tuned by using the `severity` and `bubble` arguments.

### Handles?

A handler can be passed a `Crylog::Severity` to designate the minimum level this handler should handle.  A common usage would be having an `Crylog::Handlers::IOHandler` logging all messages to a file, but have another handler that would send an email if the severity is an `Error`.

```crystal
require "crylog"

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::Handlers::IOHandler.new(STDOUT, severity: Crylog::Severity::Alert)
    ] of Crylog::Handlers::LogHandler
  end
end

main_logger = Crylog.logger
main_logger.info "I don't get printed"
STDOUT # => Nothing gets printed due to not meeting the minimum severity
main_logger.emergency "Urgent!"
STDOUT # => [2019-05-19T01:05:55.639948000Z] main.EMERGENCY: Urgent!
```

A specific handler can also override the `handles?(message : Crylog::Message) : Bool` to implement custom logic of if it should handle a message.

```crystal
struct SomeHandler < Crylog::Handlers::ProcessingLogHandler
  ...
  def handles?(message : Crylog::Message) : Bool
    # Some custom logic
  end
end
```

### Bubble

The bubble argument can be used to halt the logged message from being handled by handlers further down the line.

```crystal
require "crylog"

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::Handlers::IOHandler.new(STDOUT, bubble: false),
      Crylog::Handlers::IOHandler.new(STDOUT),
    ] of Crylog::Handlers::LogHandler
  end
end

main_logger = Crylog.logger
main_logger.info "Only printed once"
STDOUT # => [2019-05-19T01:11:04.046208000Z] main.INFO: Only printed once
STDOUT # => The message is only printed once since the first `IOHandler` does not allow messages to "bubble" up throught the array
```

### Custom Handlers

Custom handlers can also be defined.  Most of the time this would just involve creating a struct that inherits from `Crylog::Handlers::ProcessingHandler`, and implement a `write(message : Crylog::Message) : Nil` method.  Then use it when configuring your `Logger` instances.

```crystal
require "crylog"

struct CustomHandler < Crylog::Handlers::ProcessingLogHandler
  # Could define a custom initializer to pass handler specific
  # to the handler such as: data API keys, API clients etc.
  def initialize(@api_key : String, severity : Crylog::Severity = Crylog::Severity::Debug, bubble : Bool = true)
    super severity, bubble
  end

  # The logic to actually write the log message
  protected def write(message : Crylog::Message)
    # Do something
  end
end

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      CustomHandler.new("MY_API_KEY"),
    ] of Crylog::Handlers::LogHandler
  end
end
```

## Processor

A processor allows metadata to be added to all logged messages passing through a given `Logger` instance, via the message’s `extra` property.  A handler can also have processors specific to that handler.  A processor can either be a `Proc(Crylog::Message, Nil)` or an instance of `Crylog::Processors::LogProcessor` for more complex processing.

```crystal
require "crylog"

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::Handlers::IOHandler.new(STDOUT),
    ] of Crylog::Handlers::LogHandler

    logger.processors = [
      ->(message : Crylog::Message) do
        message.extra["some_key"] = "Hello world!"
        nil
      end,
    ] of Crylog::Processors::LogProcessors
  end
end

main_logger = Crylog.logger
main_logger.info "With processor"
STDOUT # => [2019-05-19T01:59:02.841349000Z] main.INFO: With processor {"some_key":"Hello world!"}
```

The main benefit of a processor, is adding information that would apply to _EVERY_ logged message, as opposed to `context` which is just applied for messages logged via that specific method.  A common example of this could be the currently logged in user/customer ids.

### Custom Processors

`Crylog` comes with some example processors, but most commonly these would be specific to a project.  To create a custom processor, simply create a struct that inherits from `Crylog::Processors::LogProcessor` that implements a `call(message : Message) : Nil` method.

```crystal
require "crylog"

struct MyProcessor < Crylog::Processors::LogProcessor
  # Initializers can also be defined to give the processor access to external data.
  def initialize(@env : String); end  
  
  def call(message : Crylog::Message) : Nil
    message.extra["current_env"] = @env
  end
end

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::Handlers::IOHandler.new(STDOUT),
    ] of Crylog::Handlers::LogHandler

    logger.processors = [
      MyProcessor.new ENV["ENV"],
    ] of Crylog::Processors::LogProcessors
  end
end

main_logger = Crylog.logger
main_logger.info "Some event"
STDOUT # => [2019-05-19T02:07:14.081841000Z] main.INFO: Some event {"current_env":"development"}
```

## Formatters

A formatter alters how a logged message will be serialized.  Each handler has a sane default for its purpose, but can also be changed.  For example messages being logged to a file would not have the same formatting needs as sending an email, or POSTing to an external service.

A formatter can either be a `Proc(Crylog::Message, String)` or an instance of `Crylog::Formatters::LogFormatter` if more complex formatting is required.  

```crystal
require "crylog"

# Instantiate a new IOHandler
io_handler = Crylog::Handlers::IOHandler.new(STDOUT)
# Change its format to recreate Crystal's Logger format
io_handler.formatter = ->(message : Crylog::Message) do
  String.build do |str|
    severity = message.severity.to_s.upcase
    str << severity[0] << ", [" << message.datetime << " #" << Process.pid << "] "
    str << severity << " -- " << message.channel << ": " << message.message
    str << ' ' << message.context.to_json << ' ' << message.extra.to_json
  end
end

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [io_handler] of Crylog::Handlers::LogHandler
  end
end

main_logger = Crylog.logger
main_logger.info "Custom format"
STDOUT # => I, [2019-05-19 22:46:33 UTC #17775] INFO -- main: Custom format {} {}
```

### Custom Formatters

To create a custom formatter, simply create a struct that inherits from `Crylog::Formatters::LogFormatter` that implements a `call(message : Message) : String` method, where the returned value is the formatted string representation of the the message.

```crystal
require "crylog"

struct MyFormatter < Crylog::Formatters::LogFormatter
  def call(message : Crylog::Message) : String
    String.build do |str|
      str << message.message << ' ' << "Logged at #{message.datetime}"
    end
  end
end

Crylog.configure do |registry|
  registry.register "main" do |logger|
    handler = Crylog::Handlers::IOHandler.new(STDOUT)
    handler.formatter = MyFormatter.new
    logger.handlers = [handler] of Crylog::Handlers::LogHandler
  end
end

main_logger = Crylog.logger
main_logger.info "Some event"
STDOUT # => Some event Logged at 2019-05-19 22:53:17 UTC
```

### Overriding Default Formatter

A handler can also override the `default_formatter : Crylog::Formatters::LogFormatter` method, which returns the formatter to use for that handler and its children.  This is most helpful for when working with abstract handlers, for example there could be an an `abstract struct MailHandler` that overrides it and sets the default formatter to use an HTML formatter.