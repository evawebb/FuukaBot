require_relative "commands/8ball.rb"
require_relative "commands/coin.rb"
require_relative "commands/exit.rb"
require_relative "commands/fplus.rb"
require_relative "commands/frozen.rb"
require_relative "commands/google.rb"
require_relative "commands/help.rb"
require_relative "commands/housecup.rb"
require_relative "commands/img.rb"
require_relative "commands/math.rb"
require_relative "commands/music.rb"
require_relative "commands/p-list.rb"
require_relative "commands/p-lower.rb"
require_relative "commands/p-raise.rb"
require_relative "commands/playing.rb"
require_relative "commands/poll.rb"
require_relative "commands/roll.rb"
require_relative "commands/twit.rb"
require_relative "commands/weather.rb"
require_relative "commands/youtube.rb"

class FuukaBot
  def initialize(bot)
    @rand = Random.new
    @commands = {
      :"8ball" => EightBallCommand.new,
      :coin => CoinCommand.new,
      :exit => ExitCommand.new,
      # :fplus => FPlusCommand.new,
      # :frozen => FrozenCommand.new,
      :google => GoogleCommand.new,
      :help => HelpCommand.new(self),
      :housecup => HouseCupCommand.new,
      # :img => ImgCommand.new,
      :math => MathCommand.new,
      :"p-list" => PListCommand.new(self),
      :"p-lower" => PLowerCommand.new(self),
      :"p-raise" => PRaiseCommand.new(self),
      :playing => PlayingCommand.new,
      :poll => PollCommand.new,
      :roll => RollCommand.new,
      :twit => TwitCommand.new,
      :weather => WeatherCommand.new,
      :youtube => YoutubeCommand.new
    }
  end

  def access_allowed(command, user)
    @commands[command].plevel <= get_plevel(user)
  end

  attr_accessor :commands
end
    
