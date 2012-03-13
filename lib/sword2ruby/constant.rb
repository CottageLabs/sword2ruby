module Sword2Ruby
  
  NS = "http://www.w3.org/2005/Atom"
  PP_NS = "http://www.w3.org/2007/app"
  
  VALID_URI_SCHEMES = [:http, :https, :file]
  
  LAMBDA_NIL_TEXT = lambda {
    def text
      nil
    end
  }
  
end