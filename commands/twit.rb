require "uri"
require "open-uri"

class TwitCommand < Command
  def initialize
    super
    @usage = "[username]"
    @tweet_regex = /<p class="[^"]*tweet-text[^"]*"[^>]*>(.*?)<\/p>/m
    @description = "Tweet tweet motherfucker"
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
          .gsub("&nbsp;", "")
          .gsub("&gt;", ">")
          .gsub("&lt;", "<")
          .gsub("pic.twitter", "http://pic.twitter")
        response = response[i..-1]
      else
        break
      end
    end

    if choices.size > 0
      r = choices.sample

      if r =~ /(.*)(http:\/\/pic\.twitter\.com.*)/
        msg = $~[1]
        url = $~[2]

        if msg.size > 0
          event.respond(msg)
        end

        img_response = open(url).read
        if img_response =~ /<div class="[^"]*photoContainer[^"]*"[^>]*data-image-url="(.*?)"/
          ext = $~[1].split(".")[-1]
          img_data = open($~[1])
          img_data.binmode
          File.open("tempfile.#{ext}", "w") do |f|
            f << img_data.read
          end
          event.message.channel.send_file(File.new("tempfile.#{ext}", "r"))
        else
          event.respond("Error sending tweet picture.")
        end
      else
        event.respond(r)
      end
    else
      event.respond("I didn't find any tweets.")
    end
  end
end
