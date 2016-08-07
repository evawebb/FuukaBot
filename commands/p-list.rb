require_relative "command.rb"

class PListCommand < Command
  def initialize(bot)
    super()
    @bot = bot
    @description = "List all of FuukaBot's commands and their current permission settings.\nLevel 1 commands can be used by anyone.\nLevel 2 commands can be used by anyone as long as they're not #{LOW_ROLE}.\nLevel 3 commands are only accessible to #{HIGH_ROLE}."
  end

  def call(event, args)
    str = "Here are the current permission settings:\n```\n"
    @bot.commands.each do |command, obj|
      str += ("%-9s %s\n" % [command.to_s, "#" * (obj.plevel + 1)])
    end
    str += "```"

    event.respond(str)
  end
end
