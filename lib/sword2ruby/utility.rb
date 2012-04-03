require 'uri'
require 'digest/md5'

module Sword2Ruby
  class Utility

    #Method to cast a (typically) string value into a boolean value
    #===Parameters
    #value:: the string value to be cast, e.g. "true" or "no"
    #nil_value:: (optional) value to return if value=nil. If not supplied, this will default to false. Typically used in circumstances when returning something other than false would be preferable if value=nil.
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

    #Method to check the supplied argument is the expected class.
    #===Parameters
    #name:: the string name of the *argument* parameter, e.g. "update_time" or "username"
    #argument:: the object to be checked against *expected_class*, e.g. update_time or username
    #expected_class:: the class used to validate *argument*, e.g. Time or String
    #It will just return (nothing) if the check passes, or raise an ArgumentError if the check fails. 
    #===Example
    # # This is fine
    # on_behalf_of = "joebloggs"
    # Utility.check_argument_class('on_behalf_of', on_behalf_of, String)
    # 
    # # This will raise an ArgumentError, because on_behalf_of is not a String
    # on_behalf_of = 12345
    # Utility.check_argument_class('on_behalf_of', on_behalf_of, String) #Raises an ArgumentError!
    def self.check_argument_class(name, argument, expected_class)
      unless argument.is_a? expected_class
        raise ArgumentError.new("Argument '#{name}=#{argument}' must be of type '#{expected_class}' (and not of type '#{argument.class}')")
      end
    end
    
    #Method to check the supplied uri uses one of the URI schemes defined in Sword2Ruby::VALID_URI_SCHEMES.
    #===Parameters
    #uri:: the string URI to be checked
    #It will just return (nothing) if the check passes, or raise an InvalidURIError if the check fails.
    #It will raise an ArgumentError if *uri* is not a String. It wil raise a URI parse error if *uri* could not be parsed.
    #===Example
    # # This is fine
    # Utility.check_uri('http://www.url.com')
    # 
    # # This will raise an InvalidURIError, because fishy:// is not a valid URI scheme
    # Utility.check_uri('fishy://www.url.com')
    def self.check_uri(uri)
      self.check_argument_class("uri", uri, String)
      unless VALID_URI_SCHEMES.include? URI.parse(uri).scheme.downcase.to_sym
        raise URI::InvalidURIError, "Invalid URI, it must start with either [#{VALID_URI_SCHEMES.join(',')}] (current value: #{uri})"
      end
    end
    
#Find link methods
    
    #Method to return the @href attribute of the Atom::Link found in an array of Atom::Links by its @rel and @type attributes.
    #===Parameters
    #links:: an array of Atom::Links
    #rel:: the string @rel value to search the array for
    #type:: (optional) the string @type value to search the array for, defaults to nil
    #It will return the href value of the first link found with matching @rel and @type values, othewise nil.
    def self.find_link_uri(links, rel, type = nil)
      links.find(NIL_LAMBDA) {|link| link.rel == rel && link.type == type}.href
    end

    #Method to return an array of Atom::Links found in an array of Atom::Links by their @rel and @type attributes.
    #===Parameters
    #links:: an array of Atom::Links
    #rel:: the string @rel value to search the array for
    #type:: (optional) the string @type value to search the array for, defaults to nil
    #It will return an array of all matching Atom:Links (found with @rel and @type values), othewise an empty array.
    def self.find_links(links, rel, type = nil)
      links.find_all{|link| link.rel == rel && link.type == type}
    end
    
    #Method to return an array of Atom::Links found in an array of Atom::Links by their @rel attributes.
    #===Parameters
    #links:: an array of Atom::Links
    #rel:: the string @rel value to search the array for
    #It will return an array of all matching Atom:Links (found with @rel), othewise an empty array.
    def self.find_links_all_types(links, rel)
      links.find_all{|link| link.rel == rel}
    end
    
    
#Find single element methods

    #Method to return the first Atom::Element found in an array of Atom::Elements by its name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element to search for, e.g. "sword:state" or "sword:verboseDescription"
    #It will return the first element found with a matching name, othewise nil.
    def self.find_element_by_name(elements, name)
      elements.find(NIL_LAMBDA) {|e| e.fully_expanded_name == name}
    end

    #Method to return the text value of first Atom::Element found in an array of Atom::Elements by its name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element to search for, e.g. "sword:state" or "sword:verboseDescription"
    #It will return the text value of first element found with a matching name, othewise nil.    
    def self.find_element_text(elements, name)
      find_element_by_name(elements, name).text
    end
    
    #Method to return the integer value of first Atom::Element found in an array of Atom::Elements by its name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element to search for, e.g. "sword:state" or "sword:verboseDescription"
    #It will return the integer value of first element found with a matching name, othewise 0.
    def self.find_element_integer(elements, name)
      find_element_text(elements, name).to_i
    end
    
    #Method to return the boolean value of first Atom::Element found in an array of Atom::Elements by its name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element to search for, e.g. "sword:state" or "sword:verboseDescription"
    #It will return the boolean value of first element found with a matching name, othewise nil.
    def self.find_element_boolean(elements, name)
       self.to_boolean(find_element_text(elements, name), nil)
    end
    
    #Method to return the time value of first Atom::Element found in an array of Atom::Elements by its name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element to search for, e.g. "sword:state" or "sword:verboseDescription"
    #It will return the time value of first element found with a matching name, othewise nil.
    def self.find_element_time(elements, name)
      value = find_element_text(elements, name)
      value.nil? ? nil : Time.parse(find_element_text(elements, name))
    end
    
    #Method to return the attribute value of first Atom::Element found in an array of Atom::Elements by its name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element to search for, e.g. "sword:state" or "sword:verboseDescription"
    #attribute_name:: the name of the attribute to return the value of, e.g. "href"
    #It will return the value of the specified attribute of the first element found with a matching name, othewise nil.
    def self.find_element_attribute_value(elements, name, attribute_name)
      elements.find(NIL_LAMBDA) {|e| e.fully_expanded_name == name}.attribute(attribute_name).value
    end
    
    #Method to return the first Atom::Element found in an array of Atom::Elements by its scheme and term.
    #===Parameters
    #elements:: an array of Atom::Elements
    #scheme:: the scheme of the element to search for, e.g. "http://purl.org/net/sword/terms/"
    #term:: the term of the element to search for, e.g. "http://purl.org/net/sword/terms/originalDeposit"
    #It will return the first element found with a matching scheme and term, othewise nil.
    def self.find_element_by_scheme_and_term(elements, scheme, term)
      elements.find {|e| e.scheme == scheme && e.term == term}
    end
    
    
    
#Find multiple elements
    
    #Method to return an array of text values of matching Atom::Elements found in an array of Atom::Elements by their name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element(s) to search for, e.g. "sword:state" or "sword:verboseDescription"
    #It will return an array of the text values of elements found with a matching name, othewise an empty array [ ].
    def self.find_elements_text(elements, name)
      elements.find_all {|e| e.fully_expanded_name==name}.collect {|e| e.text}
    end

    #Method to return an array of attribute values of matching Atom::Elements found in an array of Atom::Elements by their name.
    #===Parameters
    #elements:: an array of Atom::Elements
    #name:: the expanded name of the element(s) to search for, e.g. "sword:state" or "sword:verboseDescription"
    #attribute_name:: the name of the attributes to return the value of, e.g. "href"
    #It will return an array of the attribute values of elements found with a matching name, othewise an empty array [ ].    
    def self.find_elements_attribute_value(elements, name, attribute_name)
      elements.find_all {|e| e.fully_expanded_name==name}.collect {|e| e.attribute(attribute_name).value}
    end

    #Method to return an array of matching Atom::Elements found in an array of Atom::Elements by their namespace.
    #===Parameters
    #elements:: an array of Atom::Elements
    #namespace:: the namespace to search for, e.g. "http://purl.org/dc/terms/"
    #It will return an array of Atom::Elements found with a matching namespace, othewise an empty array [ ].    
    def self.find_elements_by_namespace(elements, namespace)
      elements.find_all {|e| e.namespace == namespace}
    end
    
  
    #Method to return an array of matching Atom::Elements found in an array of Atom::Elements by their namespace.
    #===Parameters
    #elements:: an array of Atom::Elements
    #scheme:: the scheme to search for, e.g. "http://purl.org/net/sword/terms/state"
    #It will return an array of Atom::Elements found with a matching scheme, othewise an empty array [ ].
    def self.find_elements_by_scheme(elements, scheme)
      elements.find_all {|e| e.scheme == scheme}
    end
    
    #Method to return the filename, MD5 hash and filedata of the supplied filepath.
    #===Parameters
    #filepath:: path to an existing file which must be readable to the Ruby process. 
    #Returns an array of the form [filename, md5_digest, data]
    def self.read_file(filepath) 
      data = nil
      File.open(filepath,'r') do |file|
        data = file.gets(nil) #Read entire file, no Base64.encode64()
      end #file is closed automatically
      return [File.basename(filepath), Digest::MD5.hexdigest(data), data]
    end
    
#:nodoc:    
private 
    def initialize()
      super
    end
    
  end #class
end #module