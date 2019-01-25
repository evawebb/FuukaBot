require_relative "command.rb"

class HouseCupCommand < Command
  def initialize
    super
    @description = "Find out who's winning the House Cup."
  end

  def call(event, args)
    data = read_json("data/hogwarts.json")

    houses_left = ["gryffindor", "hufflepuff", "ravenclaw", "slytherin"]
    houses_list = []
    points_list = []

    while data.size > 0
      highest_house = data.keys[0]
      highest_points = data[data.keys[0]]

      data.each do |k, v|
        if v > highest_points
          highest_house = k
          highest_points = v
        end
      end

      houses_list << highest_house
      points_list << highest_points.to_i
      data.delete(highest_house)
      houses_left.delete(highest_house)
    end

    msg = ""
    pos = true
    houses_list.each_index do |i|
      if pos && points_list[i] <= 0
        houses_left.each do |h|
          msg << "#{titlecase(h)}: **0 points**\n"
        end
        pos = false
      end
      msg << "#{titlecase(houses_list[i])}: **#{points_list[i]} points**\n"
    end
    if pos 
      houses_left.each do |h|
        msg << "#{titlecase(h)}: **0 points**\n"
      end
      pos = false
    end

    event.respond(msg)
  end
end
