require_relative "command.rb"

class CoinCommand < Command
  def initialize
    super
    @description = "Flip a coin."
  end

  def call(event, args)
    event.message.channel.send_file(File.new("imgs/#{
      rand < 0.5 ? "heads" : "tails"
    }.jpg", "r"))
  end
end
