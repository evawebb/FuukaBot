require_relative "permission.rb"

class PLowerCommand < PermissionCommand
  def initialize(bot)
    super(bot)
    @modifier = -1
    @description = "Lower the permissions level of a command by one."
  end
end
