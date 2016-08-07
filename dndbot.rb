require_relative "commands/frozen.rb"
require_relative "commands/gif.rb"
require_relative "commands/google.rb"
require_relative "commands/roll.rb"
require_relative "commands/youtube.rb"

EXTS = ["gif", "png", "jpg", "jpeg"]
FILM_LISTS = ["A–C", "D–F", "G–I", "J–L", "M–O", "P–S", "T–V", "W–Z"]
FROZEN_CHARACTERS = [["Elsa", 0.2], ["Anna", 0.4], ["Kristoff", 0.6], ["Olaf", 0.7], ["Hans", 0.8], ["Sven", 0.85], ["Oaken", 0.9], ["Grandpabbie", 0.95], ["Duke of Weselton", 0.98], ["Marshmallow", 0.9999], ["Rapunzel", 1.0]]

class DnDBot
  def initialize()
    @rand = Random.new
    @commands = {
      :frozen => FrozenCommand.new,
      :gif => GifCommand.new,
      :google => GoogleCommand.new,
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

  attr_accessor :commands
end
    
