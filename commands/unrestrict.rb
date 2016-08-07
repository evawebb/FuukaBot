require_relative "permission.rb"

class UnrestrictCommand < PermissionCommand
  def initialize(bot)
    super(bot)
    @should_restrict = false
  end

  def help(event)
    event.respond("Usage: `!unrestrict [command]`")
  end
end
