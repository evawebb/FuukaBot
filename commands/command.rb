class Command
  def help(event, command)
    if @usage.nil?
      event.respond("Usage: `!#{command}`")
    else
      event.respond("Usage: `!#{command} #{@usage}`")
    end
  end
end
    
