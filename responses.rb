hogwarts_regex = /(\-?\d+) (points )?(to|for|from) (Gryffindor|Hufflepuff|Ravenclaw|Slytherin)/i
def hogwarts_lead(data)
  lead_house = "hufflepuff"
  lead_points = data[lead_house].nil?
  lead_points ||= 0
  data.each do |k, v|
    if v > lead_points
      lead_house = k
      lead_points = v
    end
  end
  lead_house
end

$responses = [
  {
    "regex" => /best girl/i,
    "response" => Proc.new { |event|
      event.respond("its me")
    }
  },
  {
    "regex" => hogwarts_regex,
    "response" => Proc.new { |event|
      event.message.content =~ hogwarts_regex

      pts = $~[1].to_i
      if $~[3] == "from"
        pts = -pts
      end
      house = $~[4].downcase

      data = read_json("hogwarts.json")
      lead_house = hogwarts_lead(data)
      n = data.keys.size

      if data.has_key?(house)
        data[house] += pts
      else
        data[house] = pts
      end

      new_lead_house = hogwarts_lead(data)
      if new_lead_house != lead_house || n == 0
        event.respond("#{titlecase(new_lead_house)} is now in the lead, with **#{data[new_lead_house]} points**!")
      end

      write_json("hogwarts.json", data)

      nil
    }
  }
]
