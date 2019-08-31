require "json"

module Crylog
  # Represents a logged message and its metadata.
  class Message
    include JSON::Serializable

    @message : String?

    # The severity level of the logged message.
    getter severity : Severity

    # What channel the messaged was logged to.
    getter channel : String

    # When the message was logged.
    getter datetime : Time

    # Any extra metadata added by a `Crylog::Processors::LogProcessor`.
    setter extra : Hash(String, Crylog::Context)?

    @context : Hash(String, Crylog::Context)?

    # Represents the formatted version of this message.
    @[JSON::Field(ignore: true)]
    property formatted : String = ""

    # Lambda held for lazy message evaluation.
    @[JSON::Field(ignore: true)]
    @block : -> Crylog::MsgType

    @[JSON::Field(ignore: true)]
    @set_message_context = false

    def initialize(@severity : Crylog::Severity, @channel : String, &block : -> Crylog::MsgType)
      @datetime = Time.utc
      @block = block
    end

    # The message that was logged.
    def message : String
      set_message_context
      @message.not_nil!
    end

    # Any extra metadata added when the message was logged.
    def context : Hash(String, Crylog::Context)
      set_message_context
      @context.not_nil!
    end

    def extra : Hash(String, Crylog::Context)
      @extra ||= Hash(String, Crylog::Context).new
    end

    def message? : Bool
      set_message_context
      return false unless msg = @message
      !msg.empty?
    end

    def context? : Bool
      set_message_context
      return false unless ctx = @context
      !ctx.empty?
    end

    def extra? : Bool
      return false unless ext = @extra
      !ext.empty?
    end

    # Resolves the passed block setting @message and @context.
    private def set_message_context : Nil
      return if @set_message_context

      mctx = @block.call
      mctx = case mctx
             when String
               {mctx, nil}
             when {String, nil}
               mctx
             when {String, Hash(String, Crylog::Context)}
               mctx
             else
               raise "invalid types for #{mctx.inspect}"
             end

      @message, @context = mctx
      @set_message_context = true
    end

    def to_json(builder : JSON::Builder)
      set_message_context
      super
    end
  end
end
