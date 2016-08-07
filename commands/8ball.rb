require_relative "command.rb"

class EightballCommand < Command
  def initialize
    super
    @rand = Random.new
  end

  def call(event, args)
    num = @rand.rand(20) + 1
    event.message.channel.send_file(File.new("imgs/8ball/#{num}.jpg", "r"))
  end
end
