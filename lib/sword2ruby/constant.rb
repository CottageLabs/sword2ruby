module Sword2Ruby
  
  #The Atom Syndication Format namespace: http://www.w3.org/2005/Atom
  ATOM_SYNDICATION_FORMAT_NAMESPACE = "http://www.w3.org/2005/Atom"
  
  #Atom Publishing Protocol namespace: http://www.w3.org/2007/app
  ATOM_PUBLISHING_PROTOCOL_NAMESPACE = "http://www.w3.org/2007/app"
  
  #An array of valid URL schemes: http://, https:// and file://
  VALID_URI_SCHEMES = [:http, :https, :file]
  
  #A special lambda object representing the nil object, used by find() when parsing XML which may or may not contain specific elements and attributes
  NIL_LAMBDA = lambda {
    result = nil;

    def result.text
      nil
    end

    def result.href
      nil
    end

    def result.value
      nil
    end

    def result.attribute(name)
      nil
    end

    result;
  }
  
end