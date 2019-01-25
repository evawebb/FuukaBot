require_relative "command.rb"

FATE_DICE = { -1 => "-", 0 => "◦", 1 => "+" }
OP_MAPPING = {
  "+" => :+,
  "-" => :-,
  "*" => :*,
  "/" => :/,
  "d" => :+
}

class RollCommand < Command
  def initialize
    super
    @usage = "[x]d[y]"
    @description = "Roll some dice."
  end

  def build_parse_tree(raw_cmd, formatted_cmd)
    raw_cmd.strip!
    if raw_cmd =~ /^\((.*)\)$/
      raw_cmd = $~[1]
    end

    paren_level = 0
    best_split_point = nil
    raw_cmd.size.times do |i|
      c = raw_cmd[i]
      if c == "("
        paren_level += 1
      elsif c == ")"
        paren_level -= 1
      elsif paren_level == 0
        if ["*", "/"].include?(c)
          if best_split_point == nil
            best_split_point = [i, 0]
          end
        elsif ["+", "-"].include?(c)
          if best_split_point == nil || best_split_point[1] == 0
            best_split_point = [i, 1]
          end
        end
      end
    end

    if !best_split_point.nil?
      [
        raw_cmd[best_split_point[0]],
        build_parse_tree(raw_cmd[0...best_split_point[0]], formatted_cmd),
        build_parse_tree(raw_cmd[best_split_point[0]+1..-1], formatted_cmd)
      ]
    else
      if raw_cmd =~ /^(\d+)d(\d+)$/
        rolls = ["d"]
        $~[1].to_i.times do
          rolls << rand($~[2].to_i) + 1
        end
        formatted_cmd.sub!(raw_cmd, "**(#{rolls[1..-1].join(", ")})**")
        rolls
      elsif raw_cmd =~ /^(\d+)dF$/
        rolls = ["d"]
        $~[1].to_i.times do
          rolls << rand(3) - 1
        end
        formatted_cmd.sub!(raw_cmd, "**(#{rolls[1..-1].join(", ")})**")
        rolls
      elsif raw_cmd =~ /^(\d+)$/
        raw_cmd.to_i
      else
        raw_cmd
      end
    end
  end

  def execute_parse_tree(parse_tree)
    if !parse_tree.instance_of?(Array)
      parse_tree
    else
      op = parse_tree[0]
      rest = parse_tree[1..-1].map { |st| execute_parse_tree(st) }
      rest.inject(OP_MAPPING[op])
    end
  end

  def call(event, args)
    cmd = args.join(" ")
    tree = build_parse_tree(cmd.clone, cmd)
    result = execute_parse_tree(tree)

    event.respond("**#{result}** = #{cmd}")
  end
end
