require "uri"
require "open-uri"
require "json"

class WeatherCommand < Command
  def initialize
    super
    @usage = [
      "[zip code]", 
      "[zip code] [country code]",
      "[city name]",
      "[city name] [country code]",
      "[latitude] [longitude]"
    ]
    @description = "Query the current weather anywhere in the world."
    @emojis = {
      "01d" => ":sunny:",
      "01n" => ":full_moon:",
      "02d" => ":partly_sunny:",
      "02n" => ":partly_sunny:",
      "03d" => ":cloud:",
      "03n" => ":cloud:",
      "04d" => ":cloud:",
      "04n" => ":cloud:",
      "09d" => ":cloud_rain:",
      "09n" => ":cloud_rain:",
      "10d" => ":white_sun_rain_cloud:",
      "10n" => ":white_sun_rain_cloud:",
      "11d" => ":thunder_cloud_rain:",
      "11n" => ":thunder_cloud_rain:",
      "13d" => ":cloud_snow:",
      "13n" => ":cloud_snow:",
      "50d" => ":foggy:",
      "50n" => ":foggy:"
    }
  end

  def call(event, args)
    if args.size > 0
      wr = JSON.parse(open(format_request("weather", args)).read)

      city = wr["name"]
      country = wr["sys"]["country"]
      icon = wr["weather"][0]["icon"]
      desc = wr["weather"][0]["description"]
      temp = k_to_f(wr["main"]["temp"].to_f).to_i

      event.respond([
        "**Weather right now in #{city}, #{country}:**",
        "#{@emojis[icon]} #{titlecase(desc)}, #{temp}°F"
      ].join("\n"))
    else
      event.respond("no")
    end
  end

  def format_request(type, args)
    request = "http://api.openweathermap.org/data/2.5/#{type}?"

    if args.size == 1
      if args[0] =~ /^\d+$/
        request << "zip=#{args[0]}"
      else
        request << "q=#{args[0]}"
      end
    elsif args.size >= 2
      if args[0] =~ /^\d+\.?\d*$/ && args[1] =~ /^\d+\.?\d*$/
        request << "lat=#{args[0]}&lon=#{args[1]}"
      elsif args[0] =~ /\d+/
        request << "zip=#{args[0]},#{args[1]}"
      else
        # This will actually fire for cities that have a space in their names, but weirdly enough OpenWeatherMap actually handles those just fine.
        request << "q=#{args[0]},#{args[1]}"
      end
    end

    request << "&APPID=#{WEATHER_API_KEY}"
  end

  def k_to_f(k)
    k * 9 / 5 - 459.67
  end
end

