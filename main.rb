require "discordrb"
require "oauth2"
require_relative "secrets.rb"
require_relative "dndbot.rb"

bot = Discordrb::Commands::CommandBot.new(
  prefix: "!",
  token: TOKEN,
  application_id: ID
)

puts "Invite URL: #{bot.invite_url}"

bot_instance = DnDBot.new
bot_instance.commands.each do |command, obj|
  bot.command(command) do |event, *args|
    obj.call(event, args)
  end
end

bot.command(:help) do |event, *args|
  bot_instance.help(event, args)
end

bot.command(:exit) do |event|
  if event.message.author.id == ZACK_ID
    event.respond("Shutting down!")
    event.message.channel.send_file(File.new("imgs/see you space cowboy.png", "r"))

    exit
  else
    event.message.channel.send_file(File.new("imgs/really.gif", "r"))
  end
end

bot.message(with_text: "ping") do |event|
  event.respond("PONG")
end

bot.mention do |event|
  event.message.channel.send_file(File.new("imgs/me or my son.jpg", "r"))
end

bot.run
