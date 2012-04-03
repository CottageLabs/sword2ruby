module Sword2Ruby
  class User
  
    #Username for authenticating with the Sword server
    attr_accessor :username
    
    #On-Behalf-Of username for authenticating with the Sword server
    attr_accessor :on_behalf_of

    #Password for authenticating with the Sword server
    attr_accessor :password
    
    #Creates a new User object.
    #===Parameters
    #username:: (optional) string value of the username.
    #password:: (optional) string value of the password.
    #on_behalf_of:: (optional) string value indicating the username on whos behalf the actions will be performed.
    def initialize(username=nil, password=nil, on_behalf_of=nil)
      @username = username;
      @password = password;
      @on_behalf_of = on_behalf_of;
    end
    
  end #class
end #module