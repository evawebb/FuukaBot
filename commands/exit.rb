require_relative "command.rb"

class ExitCommand < Command
  def initialize
    @restricted = true
  end

  def call(event, args)
    event.respond("Shutting down!")
    event.message.channel.send_file(File.new("imgs/see you space cowboy.png", "r"))
    event.bot.stop
  end

  attr_accessor :restricted
end
