require "uri"
require "open-uri"
require "json"

links = []
episodes = {}
tags = []

i = 1
while true
  begin
    response = open("http://thefpl.us/episode/page:#{i}").read
  rescue OpenURI::HTTPError
    break
  end

  response.each_line do |l|
    if l =~ /"(https:\/\/thefpl\.us\/episode\/[^":\/]+)"/
      puts "Found link: #{$~[1]}"
      links << $~[1].gsub("https", "http")
    end
  end

  i += 1
end

links.each do |l|
  response = open(l).read
  if response =~ /itemprop="keywords" content="([^"]+)"/m
    puts "Got tags for episode: #{$~[1]}"
    t = $~[1].split(",")
    episodes[l] = t
    tags.concat(t)
  end
end

episodes["tags"] = tags.uniq

File.open("fplus.json", "w") do |f|
  f << JSON.generate(episodes)
end

