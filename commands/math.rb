require_relative "command.rb"

ORDER_OF_OPS = [
  ["+", "-"],
  ["*", "/"]
]
PAREN_EXP_REGEX = /\(([^\(\)]+)\)/

class MathCommand < Command
  def initialize
    super
    @usage = "[expression]"
    @description = "Perform a basic calculation. Currently only supports addition, subtraction, multiplication, and division. Also supports parentheses."
  end

  def call(event, args)
    begin
      result = evaluate(args.join(""))
      event.respond("#{args.join(" ")} = **#{"%.2f" % result}**")
    rescue
      event.respond("Your expression doesn't look correct to me.")
    end
  end

  def evaluate(expression)
    while expression =~ PAREN_EXP_REGEX
      expression.sub!($~[0], evaluate($~[1]).to_s)
    end

    if expression =~ /^\d+\.?\d*$/
      expression.to_f
    else
      ORDER_OF_OPS.each do |op_list|
        expression.size.times do |i|
          if op_list.include?(expression[i])
            return operate(
              expression[i],
              evaluate(expression[0...i]),
              evaluate(expression[i+1..-1])
            )
          end
        end
      end
      raise
    end
  end

  def operate(operation, a, b)
    if operation == "*"
      a * b
    elsif operation == "/"
      a / b
    elsif operation == "+"
      a + b
    elsif operation == "-"
      a - b
    end
  end
end
      
