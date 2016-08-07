require_relative "search.rb"

class GifCommand < SearchCommand
  def initialize
    super
    @base_url = "http://giphy.com/search/"
    @result_regex = /<a data-id="(\w+)" class=".*?gif-link.*?"/
    @result_url = "http://i.giphy.com/"
    @result_url_suffix = ".gif"
  end

  def call(event, args)
    unsafe_term = args.join(" ")
    safe_term = unsafe_term.tr("`=~!@#$%^&*()_+[]\{}|;':\",./<>?", "").tr(" ", "-")

    super(event, [safe_term])
  end
end
