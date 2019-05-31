require_relative "command.rb"
require "pp"

class DeleteCommand < Command
  def initialize(bot)
    super()
    @bot = bot
    @plevel = 1
    @usage = "[command]"
  end

  def call(event, args)
    pp(@bot.profile.username)
    # pp(event.bot)
    # pp(event.bot.client_id)
    event.channel.history(10).each do |msg|
      if (
        msg.author.username == @bot.profile.username &&
        msg.author.discriminator == @bot.profile.discriminator
      )
        puts "======"
        puts msg
      end
      "test"
    end
  end
end
