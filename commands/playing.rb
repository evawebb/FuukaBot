class PlayingCommand
  def initialize
    @restricted = true
  end

  def help(event)
    event.respond("Usage: `!playing [game]`")
  end

  def call(event, args)
    game = args.join(" ")
    event.bot.game = game
    nil
  end

  attr_accessor :restricted
end
