require_relative "commands/exit.rb"
require_relative "commands/frozen.rb"
require_relative "commands/gif.rb"
require_relative "commands/google.rb"
require_relative "commands/ping.rb"
require_relative "commands/playing.rb"
require_relative "commands/roll.rb"
require_relative "commands/youtube.rb"

ADMIN_ROLE = "Best Girl"

class DnDBot
  def initialize()
    @rand = Random.new
    @commands = {
      :exit => ExitCommand.new,
      :frozen => FrozenCommand.new,
      :gif => GifCommand.new,
      :google => GoogleCommand.new,
      :ping => PingCommand.new,
      :playing => PlayingCommand.new,
      :roll => RollCommand.new,
      :youtube => YoutubeCommand.new
    }
  end

  def help(event, args)
    if args.empty?
      event.respond("I know these commands:")
      event.respond("```\n#{@commands.keys.join("\n")}\n```")
    else
      command = args[0].to_sym
      if @commands.key?(command)
        @commands[command].help(event)
      else
        event.respond("I don't have a command with that name.")
      end
    end
  end

  def check_privileges(command, user)
    command_obj = @commands[command]
    return !(command_obj.respond_to?(:restricted) && command_obj.restricted) ||
      user.roles.map{ |r| r.name }.include?(ADMIN_ROLE)
  end

  attr_accessor :commands
end
    
