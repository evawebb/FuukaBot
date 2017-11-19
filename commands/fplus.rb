class FPlusCommand < Command
  def initialize
    super
    @usage = [
      "",
      "[tag]",
      "tags"
    ]
    @description = "Let FuukaBot recommend you some terrible things, read with enthusiasm."
    @eps = read_json("data/fplus.json")
    @msg_threshold = 1024
  end

  def call(event, args)
    if args.size == 0
      ep = @eps.keys.sample
      while ep == "tags"
        ep = @eps.keys.sample
      end
      event.respond(ep)
    elsif args[0] == "tags"
      s_tags = @eps["tags"].to_a.sort { |a, b| a[1] <=> b[1] }
      
      msg = ""
      curr_tags = []
      next_pair = s_tags.pop

      while !next_pair.nil?
        curr_val = next_pair[1]

        while !next_pair.nil? && next_pair[1] == curr_val
          curr_tags << next_pair[0]
          next_pair = s_tags.pop
        end

        msg << "**#{curr_val} episode#{curr_val != 1 ? "s" : ""}:**\n"
        curr_tags.each_index do |i|
          msg << "`#{curr_tags[i]}`"
          if i < curr_tags.size - 1
            msg << ", "
          else
            msg << "\n"
          end
          if msg.size > @msg_threshold
            event.respond(msg)
            msg.clear
          end
        end
        curr_tags.clear
      end

      event.respond(msg)
    else
      tag = args.join(" ")
      if @eps["tags"].keys.include?(tag)
        e = []
        @eps.each do |k, v|
          if k != "tags" && v.include?(tag)
            e << k
          end
        end
        event.respond(e.sample)
      else
        event.respond("That isn't a known F+ tag.")
      end
    end
  end
end
