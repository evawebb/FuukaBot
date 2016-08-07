require_relative "command.rb"

class EightballCommand < Command
  def call(event, args)
    num = rand(20) + 1
    event.message.channel.send_file(File.new("imgs/8ball/#{num}.jpg", "r"))
  end
end
