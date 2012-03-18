#resource.rb

#Using the atom-tools gem 2.0.5 (gem install atom-tools)
require "atom/entry" 

module Sword2Ruby
  class OldResource < Refresh
    
    attr_reader :edit_uri
    
    def atom_entry
      check_refreshed
      @atom_entry
    end
    
    def initialize(properties)
      @edit_uri = properties[:edit_uri]
      @atom_entry = nil
      super()
    end

    def load(connection)
      refresh(connection)
    end

    def refresh(connection)
      Utility.check_argument_class('connection', connection, Connection)
      @atom_entry = Atom::Entry.parse(connection.get(@edit_uri))
      super()
    end


    def to_s
      "#{@title}: #{@id} #{@edit_uri}"
    end
    
    #If accessing an unknown property of this resource, send it on to the @atom_entry instead
    def method_missing(name, *args, &block)
      atom_entry.send(name, *args, &block)
    end

  end #class
end #module