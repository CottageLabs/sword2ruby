#refresh.rb

module Sword2Ruby
  class Refresh

    attr_reader :refreshed, :last_refreshed
    
    def initialise
      @refreshed = false
      @last_refreshed = nil
    end

    def check_refreshed
      unless @refreshed 
        raise Exception, "Object (#{self}) has not been refreshed, call the refresh() method first"
      end
    end
  

protected
    def refresh
      @last_refreshed = Time.now
      @refreshed = true
    end

  end
end