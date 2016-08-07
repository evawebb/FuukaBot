require_relative "command.rb"

class PermissionCommand < Command
  def initialize(bot)
    @bot = bot
    @restricted = true
    @usage = "[command]"
  end

  def call(event, args)
    command = args[0].to_sym

    if @bot.commands.has_key?(command)
      command_obj = @bot.commands[command]
      if @bot.is_restricted(command_obj) != @should_restrict
        eval_string = @should_restrict ? "true" : "false"
        command_obj.define_singleton_method(:restricted) { eval(eval_string) }
        event.respond("Command `#{command}` has been #{@should_restrict ? "restricted" : "unrestricted"}.")
      else
        event.respond("Command `#{command}` is already #{@should_restrict ? "restricted" : "unrestricted"}.")
      end
    else
      event.respond("I don't know that command.")
    end
  end

  attr_accessor :restricted
end
