require_relative "search.rb"

class GoogleCommand < SearchCommand
  def initialize
    @base_url = "http://google.com/search?q="
    @result_regex = /<h3 class="r"><a href="\/url\?q=(.*?)&amp;sa.*?">(.*?)<\/a><\/h3>/
  end

  def help(event)
    event.respond("Usage: `!google [search term]`")
  end
end
