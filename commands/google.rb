require "uri"
require "open-uri"

class GoogleCommand
  def help(event)
    event.respond("Usage: `!google [search term]`")
  end

  def call(event, args)
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
end
