#collection.rb

require 'atom/feed'

module Sword2Ruby
  class Collection < Refresh
  
    attr_reader :collection_uri
    attr_reader :title, :description #don't use the feed version, as it is not provided

    attr_reader :accept, :accept_alternate_multipart_related
    attr_reader :sword_collection_policy, :sword_mediation, :sword_treatment

    attr_reader :sword_accept_packagings #[]
    attr_reader :sword_services #[]
    

    def atom_feed
      check_refreshed
      @atom_feed
    end
    
    def resources
      check_refreshed
      @resources
    end
    
    def initialize(collection_properties)
      @collection_uri = URI.parse(collection_properties[:href])
      @title = collection_properties[:atom_title]
      @description = collection_properties[:dcterms_abstract]
      @accept = collection_properties[:accept]
      @accept_alternate_multipart_related = collection_properties[:accept_alternate_multipart_related]
      @sword_collection_policy = collection_properties[:sword_collection_policy]
      @sword_mediation = collection_properties[:sword_mediation]
      @sword_treatment = collection_properties[:sword_treatment]
      @sword_accept_packagings = collection_properties[:sword_accept_packagings]
      @sword_services = collection_properties[:sword_services]
      
      @atom_feed = nil
      super() #call Refresh.initialize()
    end #initialize
    
    
    def load(connection)
      refresh(connection)
    end
    
    def refresh(connection)
      Utility.check_argument_class('connection', connection, Connection)
      @atom_feed = Atom::Feed.parse(connection.get(@collection_uri))
      @resources = []
      @atom_feed.entries.each do |entry|
        @resources << Resource.new({:edit_uri=>entry.edit_url})
      end
      super() #call Refresh.refresh()
    end
  
    def to_s
      "#{@title}: #{@description} #{@collection_uri}"
    end
  
    #If accessing an unknown property of this resource, send it on to the @atom_feed instead
    def method_missing(name, *args, &block)
      atom_feed.send(name, *args, &block)
    end

  end  #class
end #module

