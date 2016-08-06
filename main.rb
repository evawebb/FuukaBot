require "discordrb"
require "oauth2"
require_relative "secrets.rb"
require_relative "dndbot.rb"

bot = Discordrb::Commands::CommandBot.new(
  prefix: "!",
  token: TOKEN,
  application_id: ID)

puts "Invite URL: #{bot.invite_url}"


bot.message(with_text: "ping") do |event|
  event.respond("PONG")
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

bot_instance = DnDBot.new
bot_instance.methods.each do |method_name|
  if method_name.to_s =~ /^cmd_(.*)$/
    bot.command($~[1].to_sym) do |event, *args|
      bot_instance.send(method_name, event, args)
    end
  end
end

bot.run
