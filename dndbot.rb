require "uri"
require "open-uri"

EXTS = ["gif", "png", "jpg", "jpeg"]
FILM_LISTS = ["A–C", "D–F", "G–I", "J–L", "M–O", "P–S", "T–V", "W–Z"]
FROZEN_CHARACTERS = [["Elsa", 0.2], ["Anna", 0.4], ["Kristoff", 0.6], ["Olaf", 0.7], ["Hans", 0.8], ["Sven", 0.85], ["Oaken", 0.9], ["Grandpabbie", 0.95], ["Duke of Weselton", 0.98], ["Marshmallow", 0.9999], ["Rapunzel", 1.0]]

class DnDBot
  def initialize()
    @rand = Random.new
  end

  def cmd_bold(event, args)
    event.respond("**#{args.join(" ")}**")
  end

  def cmd_google(event, args)
    unsafe_term = args.join(" ")
    safe_term = URI.escape(unsafe_term, "@#$%&+=;:,/? ")

    response = open("http://google.com/search?q=#{safe_term}").read.gsub("\n", "")
    if response =~ /<h3 class="r"><a href="\/url\?q=(.*?)&amp;sa.*?">(.*?)<\/a><\/h3>/
      url = URI.unescape($~[1])
      title = strip_google_text($~[2])

      event.respond("**#{title}**")
      event.respond(url)
    else
      event.respond("No results found!")
    end
  end

  def strip_google_text(str)
    str.gsub("<b>", "").gsub("</b>", "").gsub("<br>", "").gsub("&amp;", "&")
  end

  def cmd_gif(event, args)
    unsafe_term = args.join(" ")
    safe_term = unsafe_term.tr("`=~!@#$%^&*()_+[]\{}|;':\",./<>?", "").tr(" ", "-")
    
    response = open("http://giphy.com/search/#{safe_term}").read
    if response =~ /<a data-id="(\w+)" class=".*?gif-link.*?"/
      event.respond("http://i.giphy.com/#{$~[1]}.gif")
    else
      event.respond("No gifs found!")
    end
  end

  def cmd_roll(event, args)
    if args.join(" ") =~ /(\d+)d(\d+)/
      rolls = []
      $~[1].to_i.times do 
        rolls << @rand.rand($~[2].to_i) + 1
      end
      sum = rolls.reduce(0, :+)
      event.respond("**#{sum}** = #{rolls.join(" + ")}")
    else
      event.respond("I don't understand that format.")
    end
  end

  def cmd_frozen(event, args)
    if args.empty?
      event.respond(random_frozen_quote)
    elsif args[0] == "ls"
      out_str = ""
      Dir["imgs/frozen/*"].sort.each do |fn|
        if fn =~ /imgs\/frozen\/(.*)\.\w+$/
          out_str << "  `#{$~[1]}`\n"
        end
      end
      event.respond("I have these Frozen images:")
      event.respond(out_str)
    else
      fn = "imgs/frozen/#{args.join(" ")}."

      EXTS.each do |ext|
        img = try_image("#{fn}#{ext}")
        if img
          event.message.channel.send_file(img)
          return
        end
      end

      event.respond("Sorry, I don't have a file with that name.")
    end
  end

  def random_frozen_quote()
    list_url = URI.escape("https://en.wikiquote.org/wiki/List_of_films_(#{FILM_LISTS[@rand.rand(FILM_LISTS.size)]})", "–")

    films = []
    film_list = open(list_url).read
    while film_list =~ /<li><i><a href="(.*?)".*?>.*?<\/a>/
      unless $~[1].include?("redlink")
        films << "https://en.wikiquote.org#{$~[1]}"
      end
      film_list = film_list[$~.end(0)..-1]
    end

    film_url = films[@rand.rand(films.size)]
    quotes = []
    quote_list = open(film_url).read
    while quote_list =~ /<li>(.*?)<\/li>/
      cutoff = $~.end(0)
      if is_quote($~[1])
        quotes << clean_quote($~[1])
      end
      quote_list = quote_list[cutoff..-1]
    end

    r = @rand.rand
    character = "placeholder"
    FROZEN_CHARACTERS.each do |c|
      if r <= c[1]
        character = c[0]
        break
      end
    end

    "*\"#{quotes[@rand.rand(quotes.size)]}\"* - **#{character}**"
  end

  def is_quote(str)
    !str.include?("href")
  end

  def clean_quote(str)
    str
      .sub(/^"/, "")
      .sub(/"$/, "")
      .gsub("<i>", "")
      .gsub("</i>", "")
      .sub(/.*?<\/b>:\s+/, "")
      .gsub("<b>", "")
      .gsub("</b>", "")
      .gsub("*", "")
  end

  def try_image(fn)
    begin
      File.new(fn, "r")
    rescue
      false
    end
  end
end
    
