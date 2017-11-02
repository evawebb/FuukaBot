require "discordrb"
require_relative "secrets.rb"
require_relative "globals.rb"
require_relative "fuuka_bot.rb"
require_relative "responses.rb"

bot = Discordrb::Commands::CommandBot.new(
  prefix: PREFIX,
  token: TOKEN,
  client_id: ID
)

puts "Invite URL: #{bot.invite_url}"

bot_instance = FuukaBot.new(bot)
bot_instance.commands.each do |command, obj|
  bot.command(command) do |event, *args|
    if bot_instance.access_allowed(command, event.message.author)
      obj.call(event, args)
    else
      access_denied(event)
    end
  end
end

bot.mention do |event|
  event.message.channel.send_file(File.new("imgs/me or my son.jpg", "r"))
end

$responses.each do |r|
  bot.message(contains: r["regex"]) do |event|
    r["response"].call(event)
  end
end

bot.run
