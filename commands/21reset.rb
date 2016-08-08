require_relative "command.rb"

class TwentyOneResetCommand < Command
  def initialize
    super
    @safety = true
    @plevel = 2
  end

  def call(event, args)
    if @safety
      event.respond("This will reset all players in the channel back to $1000. Are you sure you want to do this?\n*Re-send the command to confirm.*")
      @safety = false
    else
      money = {}
      event.channel.users.each do |u|
        money[u.id] = 1000
      end
      write_json(FILE_21, money)
      event.respond("All players' balances have been reset to $1000.")
    end
    nil
  end
end
