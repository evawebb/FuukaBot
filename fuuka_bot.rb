require_relative "commands/8ball.rb"
require_relative "commands/bestgirl.rb"
require_relative "commands/coin.rb"
require_relative "commands/exit.rb"
require_relative "commands/frozen.rb"
require_relative "commands/gif.rb"
require_relative "commands/google.rb"
# require_relative "commands/math.rb"
require_relative "commands/ping.rb"
require_relative "commands/playing.rb"
require_relative "commands/restrict.rb"
require_relative "commands/roll.rb"
require_relative "commands/unrestrict.rb"
require_relative "commands/youtube.rb"

ADMIN_ROLE = "Best Girl"

class FuukaBot
  def initialize()
    @rand = Random.new
    @commands = {
      :"8ball" => EightballCommand.new,
      :bestgirl => BestGirlCommand.new(self),
      :coin => CoinCommand.new,
      :exit => ExitCommand.new,
      :frozen => FrozenCommand.new,
      :gif => GifCommand.new,
      :google => GoogleCommand.new,
#      :math => MathCommand.new,
      :ping => PingCommand.new,
      :playing => PlayingCommand.new,
      :restrict => RestrictCommand.new(self),
      :roll => RollCommand.new,
      :unrestrict => UnrestrictCommand.new(self),
      :youtube => YoutubeCommand.new
    }
  end

  def access_allowed(command, user)
    user_plevel = get_plevel(user)
    @commands[command].plevel <= user_plevel
  end

  def get_plevel(user)
    if user.roles.map{ |r| r.name }.include?(ADMIN_ROLE)
      2
    else
      0
    end
  end

  def help(event, args)
    if args.empty?
      event.respond("I know these commands:")
      event.respond("```\n#{@commands.keys.join("\n")}\n```")
    else
      command = args[0].to_sym
      if @commands.key?(command)
        @commands[command].help(event, command.to_s)
      else
        event.respond("I don't have a command with that name.")
      end
    end
  end

  attr_accessor :commands
end
    
