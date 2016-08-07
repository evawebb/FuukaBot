class Command
  def initialize
    @plevel = 0
  end

  def help(event, command)
    if @usage.nil?
      event.respond("Usage: `!#{command}`")
    else
      event.respond("Usage: `!#{command} #{@usage}`")
    end
  end

  def modify_plevel(modifier)
    m_plevel = @plevel + modifier
    if m_plevel < 0
      "cannot be lowered further."
    elsif m_plevel > 2
      "cannot be raised further."
    else
      @plevel = m_plevel
      "have changed to #{@plevel}."
    end
  end

  attr_accessor :plevel
end
    
