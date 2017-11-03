require "uri"
require "open-uri"
require "json"

class ImgCommand < Command
  def initialize
    super
    @usage = "[search terms]"
    @description = "Grab a random image from Google Image Search."
    @img_types = {
      "\xFF\xD8\xFF".b => "jpg",
      "\x89PNG".b => "png",
      "GIF8".b => "gif"
    }
  end

  def call(event, args)
    response = open("https://www.googleapis.com/customsearch/v1?searchType=image&key=#{GOOGLE_SEARCH_API_KEY}&cx=#{GOOGLE_SEARCH_ID}&q=#{args.join("+")}").read
    results = JSON.parse(response)

    links = []
    results["items"].each do |item|
      links << item["link"]
    end

    if links.size > 0
      img_stream = nil
      while img_stream.nil?
        l = links.sample
        begin
          img_stream = open(l)
        rescue Exception
          img_stream = nil
        end
      end
      img_stream.binmode
      img_data = img_stream.read

      ext = ""
      @img_types.each do |k, v|
        if img_data[0...k.size].to_s == k
          ext = v
          break
        end
      end

      File.open("tempfile.#{ext}", "w") do |f|
        f << img_data
      end
      event.message.channel.send_file(File.new("tempfile.#{ext}", "r"))
    else
      event.respond("No results found.")
    end
  end
end
