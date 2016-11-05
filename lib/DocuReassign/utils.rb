module Utils

  def Utils.internet?
    begin
      true if open("http://www.google.com/")
    rescue
      false
    end
  end
  
  def Utils.clear
    system('clear') || system('cls')
  end

end
