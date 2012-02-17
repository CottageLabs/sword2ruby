#user.rb

module Sword2Ruby
  class User
  
    attr_accessor :username, :on_behalf_of
    attr_accessor :password
    
    def initialize(username=nil, password=nil, on_behalf_of=nil)
      @username = username;
      @password = password;
      @on_behalf_of = on_behalf_of;
    end
    
   
    
  end #class
end #module