require_relative "command.rb"

class CoinCommand < Command
  def initialize
    super
    @rand = Random.new
  end

  def call(event, args)
    event.message.channel.send_file(File.new("imgs/#{
      @rand.rand < 0.5 ? "heads" : "tails"
    }.jpg", "r"))
  end
end
