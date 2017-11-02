require "uri"
require "open-uri"

class TwitCommand < Command
  def initialize
    super
    @usage = "[username]"
    @tweet_regex = /<p class="[^"]*tweet-text[^"]*"[^>]*>(.*?)<\/p>/m
  end

  def call(event, args)
    response = open("http://twitter.com/#{args.join("")}").read
    File.open("out.txt", "w") do |f|
      f << response
    end

    choices = []
    while response.size > 0
      if response =~ @tweet_regex
        i = response.index(@tweet_regex) + $~[0].size
        choices << $~[1]
          .gsub(/<.*?>/, "")
          .gsub("&quot;", "\"")
          .gsub("&amp;", "&")
          .gsub("&#39;", "'")
          .gsub("pic.twitter", "http://pic.twitter")
        response = response[i..-1]
      else
        break
      end
    end

    if choices.size > 0
      event.respond(choices.sample)
    else
      event.respond("I didn't find any tweets.")
    end
  end
end
