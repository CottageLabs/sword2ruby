#utility.rb

require 'uri'

module Sword2Ruby
  class Utility

    
    def self.to_boolean(value, nil_value = false)
      value.downcase! if value.class == String
      case value
      when "no","false",false, "0", 0
        false
      when "yes","true",true, "1", 1
        true
      when nil
        nil_value 
      else
        !!value
      end
    end 
    
    def self.check_argument_class(name, argument, expected_class)
      unless argument.is_a? expected_class
        raise ArgumentError.new("Argument '#{name}=#{argument}' must be of type '#{expected_class}' (and not of type '#{argument.class}')")
      end
    end
    
    def self.check_uri(uri)
      self.check_argument_class("uri", uri, String)
      unless VALID_URI_SCHEMES.include? URI.parse(uri).scheme.downcase.to_sym
        raise URI::InvalidURIError, "Invalid URI, it must start with either [#{VALID_URI_SCHEMES.join(',')}] (current value: #{uri})"
      end
    end
    
private 
    def initialize()
      super
    end
    
  end #class
end #module