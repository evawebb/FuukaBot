require_relative "command.rb"

class PlayingCommand < Command
  def initialize
    super
    @usage = "[game]"
    @description = "Change what game FuukaBot is playing."
  end

  def call(event, args)
    game = args.join(" ")
    event.bot.game = game
    nil
  end
end
