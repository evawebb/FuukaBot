require "discordrb"
require_relative "secrets.rb"
require_relative "globals.rb"
require_relative "fuuka_bot.rb"

bot = Discordrb::Commands::CommandBot.new(
  prefix: "!",
  token: TOKEN,
  application_id: ID
)

puts "Invite URL: #{bot.invite_url}"

bot_instance = FuukaBot.new
bot_instance.commands.each do |command, obj|
  bot.command(command) do |event, *args|
    if bot_instance.access_allowed(command, event.message.author)
      obj.call(event, args)
    else
      access_denied(event)
    end
  end
end

bot.command(:help) do |event, *args|
  bot_instance.help(event, args)
end

bot.mention do |event|
  event.message.channel.send_file(File.new("imgs/me or my son.jpg", "r"))
end

bot.run
