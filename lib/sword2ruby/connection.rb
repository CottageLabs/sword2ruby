#connection.rb

require 'uri'
require 'atom/http'



module Sword2Ruby
  class Connection < Atom::HTTP
    
    attr_reader :user_credentials
    attr_reader :use_authentication
    attr_reader :http
    
  
    def initialize(user_credentials = nil)
      unless user_credentials.nil?
        Utility.check_argument_class('user_credentials', user_credentials, User)
      end
      @user_credentials = user_credentials
      @use_authentication = @user_credentials && @user_credentials.username && @user_credentials.password

      super()
      
      if @use_authentication
        self.user = @user_credentials.username
        self.pass = @user_credentials.password
        self.always_auth = :basic
      end
      
    end #initialize
    
  
#   def get(uri)
#     Utility.check_argument_class('uri', uri, String)
     

#     if (@user && @user.username && @user.password)       
#       resource = RestClient::Resource.new uri, :user => @user.username, :password => @user.password
#       resource.get
#     else
#       RestClient.get(uri)       
#     end
#   end #get
   
#   def post(uri, headers, content)
#     Utility.check_argument_class('uri', uri, String)
     
#     if (@user && @user.username && @user.password)       
#        resource = RestClient::Resource.new uri, :user => @user.username, :password => @user.password
#        puts content.class
#        puts content.methods
#        resource.put(content)
#     else
#        RestClient.post(uri)
#     end
#   end #post


#private
#    def request_options
#       options = {}
#       options[:http_basic_authentication] = [@user.username, @user.password] if (@user && @user.username && @user.password)
#       return options
#     end

  end  #class
end #module