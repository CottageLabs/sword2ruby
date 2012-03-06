#connection.rb

require 'uri'
require 'rest_client'

module Sword2Ruby
  class Connection
    
    attr_reader :user
    
  
    def initialize(user = nil)
      Utility.check_argument_class('user', user, User)
      @user = user
    end #initialize
  
   def get(uri)
     Utility.check_argument_class('uri', uri, String)     
     if (@user && @user.username && @user.password)       
       resource = RestClient::Resource.new uri, :user => @user.username, :password => @user.password
       resource.get
     else
       RestClient.get(uri)       
     end
   end #get
   
   def post(uri, headers, content)
     Utility.check_argument_class('uri', uri, String)
#     uri.post
   end #post


#private
#    def request_options
#       options = {}
#       options[:http_basic_authentication] = [@user.username, @user.password] if (@user && @user.username && @user.password)
#       return options
#     end

  end  #class
end #module