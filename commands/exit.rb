require_relative "command.rb"

class ExitCommand < Command
  def initialize
    super
    @plevel = 2
    @description = "Shut down FuukaBot."
  end

  def call(event, args)
    event.respond("Shutting down!")
    event.message.channel.send_file(File.new("imgs/see you space cowboy.png", "r"))
    event.bot.stop
  end
end
