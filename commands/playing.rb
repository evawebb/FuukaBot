require_relative "command.rb"

class PlayingCommand < Command
  def initialize
    super
    @plevel = 1
    @usage = "[game]"
  end

  def call(event, args)
    game = args.join(" ")
    event.bot.game = game
    nil
  end
end
