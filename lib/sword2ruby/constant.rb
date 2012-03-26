module Sword2Ruby
  
  NS = "http://www.w3.org/2005/Atom"
  PP_NS = "http://www.w3.org/2007/app"
  
  VALID_URI_SCHEMES = [:http, :https, :file]
  
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