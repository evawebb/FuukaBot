require_relative "permission.rb"

class PRaiseCommand < PermissionCommand
  def initialize(bot)
    super(bot)
    @modifier = 1
    @description = "Raise the permissions level of a command by one."
  end
end
