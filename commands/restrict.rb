require_relative "permission.rb"

class RestrictCommand < PermissionCommand
  def initialize(bot)
    super(bot)
    @should_restrict = true
  end
end
