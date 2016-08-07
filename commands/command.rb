class Command
  def initialize
    @plevel = 1
  end

  def help(event, command)
    str = ""
    if @usage.nil?
      str += "**Usage:** `#{PREFIX}#{command}`\n"
    elsif @usage.kind_of?(Array)
      str += "**Usages:**\n```\n"
      str += @usage.map{ |u| "#{PREFIX}#{command} #{u}" }.join("\n")
      str += "```"
    else
      str += "**Usage:** `#{PREFIX}#{command} #{@usage}`\n"
    end

    if !@description.nil?
      str += "*#{@description}*"
    end

    event.respond(str)
  end

  def modify_plevel(modifier)
    m_plevel = @plevel + modifier
    if m_plevel < 0
      "cannot be lowered further."
    elsif m_plevel > 2
      "cannot be raised further."
    else
      @plevel = m_plevel
      "have changed to #{@plevel + 1}."
    end
  end

  attr_accessor :plevel
end
    
