#resource.rb


module Sword2Ruby
  class Resource
    attr_reader :edit_uri
    
    def initialize(edit_uri)
      @edit_uri = edit_uri
    end

  end #class
end #module