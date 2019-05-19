# Documentation

Crylog is a flexible logging framework based on [Monolog](https://github.com/Seldaek/monolog).  It allows sending log messages to various locations such as files, external web services, and/or databases.

## Core Concepts

* Logger - An instance of `Logger` that logs messages, optionally with context. 
* Handler - Writes the log message to somewhere/something.
* Processor - Adds metadata to each logged message.
* Formatter - Determines how a logged message appears.

### Severity

`Crylog` uses the log levels as described in [RFC-5424](https://tools.ietf.org/html/rfc5424#section-6.2.1):

- Emergency: system is unusable
- Alert: action must be taken immediately
- Critical: critical conditions
- Error: error conditions
- Warning: warning conditions
- Notice: normal but significant condition
- Informational: informational messages
- Debug: debug-level messages

Convenience methods are defined for each i.e. `logger.info`, `logger.alert`, etc.

## Logger

The core class of `Crylog` is the `Logger`.  A `Logger` instance is what is used to log a message.  Each instance has a name, or channel, that is used to identify that specific `Logger` instance.  

`Logger` instances can be defined via the `Crylog.configure` method.

```crystal
require "crylog"

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::IOHandler.new(STDOUT)
    ] of Crylog::LogHandler
  end

  registry.register "worker" do |logger|
    logger.handlers = [
      Crylog::IOHandler.new(STDOUT)
    ] of Crylog::LogHandler
  end
end
```

This registers two `Logger` instances with the name `main`, and `worker` each with a single handler that will print each message to standard out.  Each `Logger` instance can have their own handlers, processors, and formatters.

A `Logger` instance can be retrieved by using the `Crylog.logger(channel : String)` method.

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

A handler can be passed a `Crylog::Severity` to designate the minimum level this handler should handle.  A common usage would be having an `IOHandler` logging all messages to a file, but have another handler that would send an email if the severity is an `Error`.

```crystal
require "crylog"

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::IOHandler.new(STDOUT, severity: Crylog::Severity::Alert)
    ] of Crylog::LogHandler
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
struct SomeHandler < Crylog::ProcessingLogHandler
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
      Crylog::IOHandler.new(STDOUT, bubble: false),
      Crylog::IOHandler.new(STDOUT),
    ] of Crylog::LogHandler
  end
end

main_logger = Crylog.logger
main_logger.info "Only printed once"
STDOUT # => [2019-05-19T01:11:04.046208000Z] main.INFO: Only printed once
STDOUT # => The message is only printed once since the first `IOHandler` does not allow messages to continue
```

### Custom Handlers

Custom handlers can also be defined.  Most of the time this would just involve creating a struct that inherits from `Crylog::ProcessingHandler`, and implement a `write(message : Crylog::Message) : Nil` method.  Then use it when configuring your `Logger` instances.

```crystal
require "crylog"

struct CustomHandler < Crylog::ProcessingLogHandler
  # Could define a custom initializer to pass handler specific
  # to the handler such as: data API keys, API clients etc.
  def initialize(@api_key : String, severity : Crylog::Severity = Crylog::Severity::Debug, bubble : Bool = true)
    super severity, bubble
  end

  # The logic to actually write the log message
  protected def write(message : Message)
    # Do something
  end
end

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      CustomHandler.new("MY_API_KEY"),
    ] of Crylog::LogHandler
  end
end
```

## Processor

A processor allows metadata to be added to all logged messages passing through a given `Logger` instance, via the message’s `extra` property.  A handler can also have processors specific to that handler.  A processor can either be an instance of `LogProcessor` struct or a `Proc(Crylog::Message, Nil)`.

```crystal
require "crylog"

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::IOHandler.new(STDOUT),
    ] of Crylog::LogHandler

    logger.processors = [
      ->(message : Crylog::Message) do
        message.extra["some_key"] = "Hello world!"
        nil
      end,
    ] of Crylog::LogProcessors
  end
end

main_logger = Crylog.logger
main_logger.info "With processor"
STDOUT # => [2019-05-19T01:59:02.841349000Z] main.INFO: With processor {"some_key":"Hello world!"}
```

The main benefit of a processor, is adding information that would apply to _EVERY_ logged message, as opposed to `context` which is just applied for messaged logged via that specific method.  A common example of this could be the currently logged in user/customer ids.

### Custom Processors

`Crylog` comes with some example processors, but most commonly these would be specific to a project.  To create a custom processor, simply create a struct that inherits from `Crylog::LogProcessor` that implements a `call(msg : Message) : Nil` method.

```crystal
require "crylog"

struct MyProcessor < Crylog::LogProcessor
  # Initializers can also be defined to give the processor access to external data.
  def initialize(@env : String); end  
  
  def call(msg : Crylog::Message) : Nil
    msg.extra["current_env"] = @env
  end
end

Crylog.configure do |registry|
  registry.register "main" do |logger|
    logger.handlers = [
      Crylog::IOHandler.new(STDOUT),
    ] of Crylog::LogHandler

    logger.processors = [
      MyProcessor.new ENV["ENV"],
    ] of Crylog::LogProcessors
  end
end

main_logger = Crylog.logger
main_logger.info "Some event"
STDOUT # => [2019-05-19T02:07:14.081841000Z] main.INFO: Some event {"current_env":"development"}
```
