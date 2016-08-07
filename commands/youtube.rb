require "uri"
require "open-uri"

class YoutubeCommand
  def help(event)
    event.respond("Usage: `!youtube [search term]`")
  end

  def call(event, args)
    unsafe_term = args.join(" ")
    safe_term = URI.escape(unsafe_term, "@#$%&+=;:,/? ")

    response = open("https://youtube.com/results?search_query=#{safe_term}").read.gsub("\n", "")
    if response =~ /<h3 class="yt-lockup-title "><a href="(.*?)"/
      url = "https://youtube.com#{URI.unescape($~[1])}"

      event.respond(url)
    else
      event.respond("No results found!")
    end
  end
end
