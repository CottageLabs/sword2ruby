#utility.rb

require 'uri'
require 'digest/md5'

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
    
    def self.find_link_uri(links, rel, type = nil)
      links.find(NIL_LAMBDA) {|link| link.rel == rel && link.type == type}.href
    end

    def self.find_links(links, rel, type = nil)
      links.find_all{|link| link.rel == rel && link.type == type}
    end
    
    def self.find_links_all_types(links, rel)
      links.find_all{|link| link.rel == rel}
    end
    
    def self.find_extension_string(extensions, name)
      extensions.find(NIL_LAMBDA) {|e| e.fully_expanded_name==name}.text
    end
    
    def self.find_extension_integer(extensions, name)
      find_extension_string(extensions, name).to_i
    end
    
    def self.find_extension_boolean(extensions, name)
       value = find_extension_string(extensions, name).downcase.chomp
       if value=="true"
         true
       elsif value=="false"
         false
       else
         nil
       end
     end
    
    def self.find_extensions_string(extensions, name)
      extensions.find_all {|e| e.fully_expanded_name==name}.collect {|e| e.text}
    end
    
    def self.find_extensions_by_namespace(extensions, namespace)
      extensions.find_all {|e| e.namespace == namespace}
    end
    
    
    #Returns [filename, md5 digest, data]
    def self.read_file(filepath) 
      data = nil
      File.open(filepath,'r') do |file|
        data = file.gets(nil) #Read entire file, no Base64.encode64()
      end #file is closed automatically
      return [File.basename(filepath), Digest::MD5.hexdigest(data), data]
    end
    
private 
    def initialize()
      super
    end
    
  end #class
end #module