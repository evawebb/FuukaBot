require_relative "permission.rb"

class PRaiseCommand < PermissionCommand
  def initialize(bot)
    super(bot)
    @modifier = 1
  end
end
