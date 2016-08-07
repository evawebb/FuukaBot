require_relative "command.rb"

class BestGirlCommand < Command
  def initialize(bot)
    @bot = bot
  end

  def call(event, args)
    @bot.commands[:google].call(event, ["fuuka", "yamagishi"])
  end
end
