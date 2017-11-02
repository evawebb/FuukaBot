require_relative "command.rb"

class MabufuCommand < Command
  def initialize
    super
    @plevel = 0
    @description = "Mabufu is a Ice skill. It deals light Ice damage to all foes. It costs 10SP to use."
  end

  def call(event, args)
    event.respond("Bufula!")
  end
end
