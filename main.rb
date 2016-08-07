require "discordrb"
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
    if bot_instance.check_privileges(command, event.message.author)
      obj.call(event, args)
    else
      event.respond("You don't have privileges for that!")
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
