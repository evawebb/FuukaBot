require "uri"
require "open-uri"

class GifCommand
  def help(event)
    event.respond("Usage: `!gif [search term]`")
  end

  def call(event, args)
    unsafe_term = args.join(" ")
    safe_term = unsafe_term.tr("`=~!@#$%^&*()_+[]\{}|;':\",./<>?", "").tr(" ", "-")

    response = open("http://giphy.com/search/#{safe_term}").read
    if response =~ /<a data-id="(\w+)" class=".*?gif-link.*?"/
      event.respond("http://i.giphy.com/#{$~[1]}.gif")
    else
      event.respond("No gifs found!")
    end
  end
end
