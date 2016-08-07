class CoinCommand
  def initialize
    @rand = Random.new
  end

  def help(event)
    event.respond("Usage: `!coin`")
  end

  def call(event, args)
    event.message.channel.send_file(File.new("imgs/#{
      @rand.rand < 0.5 ? "heads" : "tails"
    }.jpg", "r"))
  end
end
