require_relative "permission.rb"

class PLowerCommand < PermissionCommand
  def initialize(bot)
    super(bot)
    @modifier = -1
  end
end
