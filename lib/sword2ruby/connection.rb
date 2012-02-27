#connection.rb

require 'uri'
require 'open-uri'

module Sword2Ruby
  class Connection
    
    attr_reader :user
    
  
    def initialize(user = nil)
      unless user.is_a? User
        raise ArgumentError.new("user '#{user}' must be of type User (and not of type '#{user.class}')")
      end
      @user = user
    end #initialize
  
   def get(uri)
     unless uri.is_a? URI
       raise ArgumentError.new("uri '#{uri}' must be of type 'URI' (and not of type '#{uri.class}')")
     end
    
     uri.read(request_options)
   end #get


private
    def request_options
       options = {}
       options[:http_basic_authentication] = [@user.username, @user.password] if (@user && @user.username && @user.password)
       return options
     end

  end  #class
end #module