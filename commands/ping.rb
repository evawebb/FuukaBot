require_relative "command.rb"

class PingCommand < Command
  def call(event, args)
    event.respond("PONG")
  end
end
