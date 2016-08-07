require_relative "command.rb"

class PingCommand < Command
  def initialize
    super
    @plevel = 0
  end

  def call(event, args)
    event.respond("PONG")
  end
end
