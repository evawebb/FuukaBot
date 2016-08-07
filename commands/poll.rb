require_relative "command.rb"

class PollCommand < Command
  def initialize
    super
    @usage = ["open \"[question]\" \"[answer one]\" \"[answer two]\" ...", "vote [letter]", "close"]
    @description = "Interact with a poll. Each user gets only one vote."
    @question = ""
    @creator = -1
    @options = []
    @votes = []
    @participants = []
  end

  def call(event, args)
    if args[0] == "open"
      open(event, quote_split(args[1..-1].join(" ")))
    elsif args[0] == "vote"
      vote(event, args[1..-1])
    elsif args[0] == "close"
      close(event)
    else
      event.respond("Sorry, `#{args[0]}` is not a valid poll option.")
    end
  end

  def open(event, args)
    if !@question.empty?
      event.respond("Please wait until the current poll has finished before starting a new one.")
    elsif args.size < 3
      event.respond("Please provide a question and at least two options.")
    else
      @question = args[0]
      @creator = event.message.author.id
      @options = args[1..-1]
      @votes = @options.map{ 0 }
      @participants = []

      str =  "A new poll has been created by #{event.message.author.mention}!\n"
      str += "**Question:** #{@question}\n"
      str += "**Options:**\n```\n"
      @options.size.times do |i|
        str += "#{(i + 65).chr}: #{@options[i]}\n"
      end
      str += "```\nUse `#{PREFIX}poll vote [letter]` to cast your vote!"
      event.respond(str)
    end
  end

  def vote(event, args)
    if @question.empty?
      event.respond("There's no poll to vote in at the moment.")
    elsif args.empty?
      event.respond("Please choose an option.")
    elsif @participants.include?(event.message.author.id)
      event.respond("#{event.message.author.mention}, you've already voted in this poll.")
    else
      i = args[0][0].downcase.ord - 97
      if i < 0 || i >= @options.size
        event.respond("#{event.message.author.mention}, please choose a valid option.")
      else
        @votes[i] += 1
        @participants << event.message.author.id
        event.respond("#{event.message.author.mention}, your vote has been recorded.")
      end
    end
  end

  def close(event)
    if @question.empty?
      event.respond("Theres no poll to close at the moment.")
    elsif event.message.author.id != @creator && get_plevel(event.message.author) != 2
      event.respond("Only the poll creator can close the poll.")
    else
      sorted_results = []
      indices = (0...@options.size).to_a
      while @options.size > 0
        i = @votes.index(@votes.max)
        sorted_results << [indices[i], @options[i], @votes[i]]
        indices.delete_at(i)
        @options.delete_at(i)
        @votes.delete_at(i)
      end

      str =  "The poll has finished!\n"
      str += "**Question:** #{@question}\n"
      str += "**Results:**\n```\n"
      sorted_results.each do |result|
        str += "#{(result[0] + 65).chr}: #{result[1]} [#{result[2]} votes]\n"
      end
      str += "```"

      @question = ""
      @creator = -1
      @options = []
      @votes = []
      @participants = []

      event.respond(str)
    end
  end

  def quote_split(str)
    results = [""]

    in_quote = false
    str.each_char do |c|
      if c == "\""
        in_quote = !in_quote
      elsif c == " " && !in_quote
        results << ""
      else
        results[-1] << c
      end
    end

    results
  end
end
