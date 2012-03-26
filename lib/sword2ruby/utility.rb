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
    



    #Find single element
    def self.find_element_by_name(elements, name)
      elements.find(NIL_LAMBDA) {|e| e.fully_expanded_name == name}
    end
    
    def self.find_element_text(elements, name)
      find_element_by_name(elements, name).text
    end
    
    def self.find_element_integer(elements, name)
      find_element_text(elements, name).to_i
    end
    
    def self.find_element_boolean(elements, name)
       self.to_boolean(find_element_text(elements, name), nil)
     end
    
    def self.find_element_time(elements, name)
      value = find_element_text(elements, name)
      value.nil? ? nil : Time.parse(find_element_text(elements, name))
    end
    
    def self.find_element_attribute_value(elements, name, attribute_name)
      elements.find(NIL_LAMBDA) {|e| e.fully_expanded_name == name}.attribute(attribute_name).value
    end
    
    def self.find_element_by_scheme_and_term(elements, scheme, term)
      elements.find {|e| e.scheme == scheme && e.term == term}
    end
    
    
    
    #Find multiple elements
    def self.find_elements_text(elements, name)
      elements.find_all {|e| e.fully_expanded_name==name}.collect {|e| e.text}
    end
    
    def self.find_elements_attribute_value(elements, name, attribute_name)
      elements.find_all {|e| e.fully_expanded_name==name}.collect {|e| e.attribute(attribute_name).value}
    end
    
    def self.find_elements_by_namespace(elements, namespace)
      elements.find_all {|e| e.namespace == namespace}
    end
    
  
    
    def self.find_elements_by_scheme(categories, scheme)
      categories.find_all {|c| c.scheme == scheme}
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