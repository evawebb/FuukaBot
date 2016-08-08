require_relative "command.rb"
require_relative "21.cards.rb"

=begin
TODO:
- dealer blackjack
- surrender
- maybe split?
=end

class TwentyOneCommand < Command
  def initialize
    super
    @deck = shuffle
    @players = []
    @standby_players = []
    @bets = {}
    @hands = {}
    @dealer = []
    @phase = ""
  end

  def call(event, args)
    @balances = read_json(FILE_21)
    if args[0] == "balance"
      balance(event, args[1..-1])
    elsif args[0] == "standing"
      standing(event)
    elsif args[0] == "opt-in"
      opt_in(event)
    elsif args[0] == "opt-out"
      opt_out(event)
    elsif args[0] == "bet"
      bet(event, args[1..-1])
    elsif args[0] == "deal"
      deal(event)
    elsif args[0] == "hit"
      hit(event)
    elsif args[0] == "stand"
      stand(event)
    elsif args[0] == "double"
      double(event)
    end
  end

  def shuffle
    deck = []
    from = CARDS.clone

    while !from.empty?
      i = rand(from.size)
      deck << from[i]
      from.delete_at(i)
    end
    
    deck
  end
  

  def balance(event, args)
    username = ""
    if args.empty?
      username = event.message.author.name 
    else
      username = args.join(" ")
    end

    bal = get_balance(event.channel.users, username)
    if bal.nil?
      event.respond("I don't have a balance for that user.")
    else
      event.respond("#{username}'s balance is $#{bal.to_i}.")
    end
  end

  def get_balance(users, username)
    id = -1
    users.each do |u|
      this_name = u.nickname.nil? ? u.name : u.nickname
      if this_name == username
        id = u.id.to_s
        break
      end
    end

    if id == -1 || !@balances.keys.include?(id)
      nil
    else  
      @balances[id]
    end
  end

  def standing(event)
    bals = get_all_balances(event.channel.users)
    str = "**Current standing:**\n"
    bals.each_index do |i|
      str << "#{i + 1}. #{bals[i]}\n"
    end
    event.respond(str)
  end

  def get_all_balances(users)
    list = []
    @balances.each do |id, bal|
      name = ""
      users.each do |u|
        if u.id.to_s == id
          name = u.nickname.nil? ? u.name : u.nickname
          break
        end
      end
      
      if !name.empty?
        list << [name, bal]
      end
    end

    list
      .sort_by { |e| e[1] }.reverse
      .map { |e| "#{e[0]}, with $#{e[1]}" }
  end

  def opt_in(event)
    mention = event.message.author.mention
    id = event.message.author.id
    if !@players.include?(id) && !@standby_players.include?(id)
      if @phase == "betting" || @phase == ""
        @players << id
        event.respond("Welcome to the table, #{mention}! Please place your bet with `#{PREFIX}21 bet [value]`.")
        @phase = "betting"
      else
        @standby_players << id
        event.respond("Welcome to the table, #{mention}! I'll deal you in on the next hand.")
      end
    end
    nil
  end

  def opt_out(event)
    mention = event.message.author.mention
    id = event.message.author.id
    if @players.include?(id)
      @players.delete(id)
      event.respond("Thanks for playing, #{mention}!")
    elsif @standby_players.include?(id)
      @standby_players.delete(id)
      event.respond("Thanks for playing, #{mention}!")
    end
    if @players.empty? && @standby_players.empty?
      @phase = ""
    end
  end

  def bet(event, args)
    amt = args.join("")
    if @players.include?(event.message.author.id) && amt =~ /^\d+$/
      @bets[event.message.author.id] = amt.to_i
      event.respond("#{event.message.author.mention} is betting $#{amt.to_i}.")
    end
  end

  def deal(event)
    if @phase == "betting"
      no_bets = @players.select do |id|
        !@bets.keys.include?(id)
      end
      if no_bets.size > 0
        event.respond("The following players have not placed their bets yet: #{ no_bets.map{ |id| "<@#{id}>"}.join(", ") }.")
      else
        @bets.each do |id, bet|
          @balances[id.to_s] -= bet
        end
        write_json(FILE_21, @balances)

        @players.each do |id|
          @hands[id] = [draw]
        end
        @dealer = [draw]
        @players.each do |id|
          @hands[id] << draw
        end
        @dealer << draw

        @phase = "playing: #{@players[0]}"

        str = "State of the table:\n"
        str << "Dealer: #{@dealer[0].to_s}, :flower_playing_cards:\n"
        @hands.each do |id, hand|
          str << "<@#{id}>: #{hand.map{ |c| c.to_s }.join(", ")}\n"
        end
        event.respond(str)
        start_turn(event, 0)
      end
    end
    nil
  end

  def start_turn(event, index)
    if index >= @players.size
      end_hand(event)
    else
      id = @players[index]
      if sum(@hands[id]) == -21
        event.respond("Blackjack! <@#{id}> wins $#{(@bets[id] * 1.5).to_i}!")
        @balances[id.to_s] += (@bets[id] * 2.5).to_i
        @bets.delete(id)
        start_turn(event, index + 1)
      else
        event.respond("It's your turn, <@#{id}>. What will you do?")
        @phase = "playing #{index}"
      end
    end
  end

  def end_hand(event)
    event.respond("Dealer:")
    while dealer_hits
      event.respond(@dealer.map{ |c| c.to_s }.join(", "))
      @dealer << draw
    end
    event.respond(@dealer.map{ |c| c.to_s }.join(", "))

    dealer_sum = sum(@dealer).abs
    if dealer_sum > 21
      event.respond("Dealer busted!")
    end

    @bets.each do |id, bet|
      player_sum = sum(@hands[id]).abs
      if player_sum > dealer_sum || dealer_sum > 21
        event.respond("<@#{id}> wins $#{bet}!")
        @balances[id.to_s] += 2 * bet
      elsif player_sum == dealer_sum
        event.respond("<@#{id}> pushes.")
        @balances[id.to_s] += bet
      end
    end
    write_json(FILE_21, @balances)

    event.respond("The hand is over! Everyone, please place your bets using `#{PREFIX}21 bet [amount]`.")

    @phase = "betting"
    @players.concat(@standby_players)
    @standby_players.clear
    @bets = {}
    @hands = {}
  end

  def dealer_hits
    s = sum(@dealer)
    if s < 0
      s.abs <= 17
    else
      s < 17
    end
  end

  def hit(event)
    id = event.message.author.id
    if @players.include?(id)
      index = @players.index(id)
      if @phase == "playing #{index}"
        @hands[id] << draw
        event.respond(@hands[id].map{ |c| c.to_s }.join(", "))
        if sum(@hands[id]) > 21
          event.respond("Busted!")
          @bets.delete(id)
          start_turn(event, index + 1)
        end
      end
    end
    nil
  end

  def stand(event)
    id = event.message.author.id
    if @players.include?(id)
      index = @players.index(id)
      if @phase == "playing #{index}"
        start_turn(event, index + 1)
      end
    end
    nil
  end

  def double(event)
    id = event.message.author.id
    if @players.include?(id)
      index = @players.index(id)
      if @phase == "playing #{index}"
        @balances[id.to_s] -= @bets[id]
        write_json(FILE_21, @balances)
        @bets[id] *= 2
        hit(event)
        if @phase == "playing #{index}"
          stand(event)
        end
      end
    end
  end

  def draw
    if @deck.size == 0
      @deck = shuffle
    end
    @deck.pop
  end

  def sum(hand)
    has_ace = false
    sum = 0
    hand.each do |c|
      sum += c.val
      if c.val == 1
        has_ace = true
      end
    end

    if has_ace && sum + 10 <= 21
      -(sum + 10)
    else
      sum
    end
  end
end
