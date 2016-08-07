require "uri"
require_relative "command.rb"

class MusicCommand < Command
  def initialize(bot)
    super()
    @bot = bot
  end

  def call(event, args)
    if !File.directory?(BASE_MUSIC_PATH)
      event.respond("Sorry, Zack's music library is not connected right now!")
    else
      if args[0] == "connect"
        connect(event, args[1..-1])
      elsif args[0] == "play"
        play(event, args[1..-1])
      elsif args[0] == "ls"
        ls(event, args[1..-1])
      end
    end
    nil
  end

  def connect(event, args)
    if connected?
      event.respond("I'm already connected to a voice channel!")
    else
      room = args.join(" ")
      event.server.channels.each do |ch|
        if ch.type == "voice" && ch.name == room
          @bot.voice_connect(ch)
          event.respond("Connected to voice channel \"#{room}\".")
          break
        end
      end

      if !connected?
        event.respond("I couldn't find that voice channel.")
      end
    end
  end

  def play(event, args)
    if !connected?
      event.respond("I have to be connected to a voice channel first.")
    else
      rel_path = args.join(" ").gsub("..", "")
      full_path = "#{BASE_MUSIC_PATH}/#{rel_path}"
      
      if File.file?(full_path) && full_path =~ /\.mp3$/
        event.respond("Playing `#{rel_path}`")
        event.voice.play_file(full_path)
      else
        event.respond("Invalid path.")
      end
    end
    nil
  end

  def ls(event, args)
    rel_path = args.join(" ").gsub("..", "")
    full_path = "#{BASE_MUSIC_PATH}/#{rel_path}"

    if File.directory?(full_path)
      strs = ["```\n#{rel_path.gsub(/\/+/, "/")}\n"]
      Dir[full_path + "/*"].sort.each do |fn|
        strs[-1] << "  " << fn.split("/")[-1]
        strs[-1] << (File.directory?(fn) ? "/\n" : "\n")
        if strs[-1].length > MESSAGE_LIMIT
          strs[-1] << "```"
          strs << "```"
        end
      end
      strs[-1] << "```"
      strs.each { |s| event.respond(s) }
    else
      event.respond("Invalid path.")
    end
  end

  def connected?
    !@bot.voices.empty?
  end
end
