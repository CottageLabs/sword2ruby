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

  end  #class
end #module