#collection.rb

#require 'atom'
require 'rexml/document'


module Sword2Ruby
  class Collection < Refresh
  
    attr_reader :collection_uri, :title, :description
    
    attr_reader :accept, :accept_alternate_multipart_related
    attr_reader :sword_collection_policy, :sword_mediation, :sword_treatment
    
    attr_reader :sword_accept_packagings #[]
    attr_reader :sword_services #[]
    
    def collection_document
      check_refreshed
      @collection_document
    end
    
    def resources()
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
      
      @collection_document = nil
      @resources = nil
      
      super() #call Refresh.initialize()
    end #initialize
    
    def to_s
      "#{@title}: #{@description} #{@collection_uri}"
    end
    
    def load(connection)
      refresh(connection)
    end
    
    def refresh(connection)
      Utility.check_argument_class('connection', connection, Connection)
      @collection_document = REXML::Document.new(connection.get(@collection_uri))
      @resources = []

      @collection_document.elements.each("/feed/entry/link") do |link|
        @resources <<  Resource.new(link.attributes)
      end
      
      super() #call Refresh.refresh()
    end
  

  end  #class
end #module