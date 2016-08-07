require_relative "permission.rb"

class RestrictCommand < PermissionCommand
  def initialize(bot)
    super(bot)
    @should_restrict = true
  end

  def help(event)
    event.respond("Usage: `!restrict [command]`")
  end
end
