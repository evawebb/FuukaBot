require_relative "command.rb"

FATE_DICE = { -1 => "-", 0 => "◦", 1 => "+" }

class RollCommand < Command
  def initialize
    super
    @usage = "[x]d[y]"
    @description = "Roll some dice."
  end

  def call(event, args)
    if args.join(" ") =~ /(\d+)d(\d+)/
      rolls = []
      $~[1].to_i.times do 
        rolls << rand($~[2].to_i) + 1
      end
      sum = rolls.reduce(0, :+)
      event.respond("**#{sum}** = #{rolls.join(" + ")}")
    elsif args.join(" ") =~ /(\d+)dF/
      rolls = []
      $~[1].to_i.times do
        rolls << rand(3) - 1
      end
      sum = rolls.reduce(0, :+)
      formatted_rolls = rolls.map{ |v| FATE_DICE[v] }
      event.respond("**#{sum}** = #{formatted_rolls.join(", ")}")
    else
      event.respond("I don't understand that format.")
    end
  end
end
