class PingCommand
  def help(event)
    event.respond("Usage: `!ping`")
  end

  def call(event, args)
    event.respond("PONG")
  end
end
