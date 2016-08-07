require_relative "command.rb"

class HelpCommand < Command
  def initialize(bot)
    super()
    @bot = bot
    @usage = ["", "[command]"]
    @description = "Explore the commands FuukaBot has to offer."
  end

  def call(event, args)
    if args.empty?
      str = "I know these commands:\n"
      str += "```\n#{@bot.commands.keys.join("\n")}```"
      event.respond(str)
    else
      command = args[0].to_sym
      if @bot.commands.key?(command)
        @bot.commands[command].help(event, command.to_s)
      else
        event.respond("I don't have a command with that name.")
      end
    end
  end
end
