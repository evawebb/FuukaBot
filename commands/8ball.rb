class EightballCommand
  def initialize
    @rand = Random.new
  end

  def help(event)
    event.respond("Usage: `!8ball`")
  end

  def call(event, args)
    num = @rand.rand(20) + 1
    event.message.channel.send_file(File.new("imgs/8ball/#{num}.jpg", "r"))
  end
end
