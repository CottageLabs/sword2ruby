#collection.rb

#require 'atom'

module Sword2Ruby
  class Collection
  
    attr_reader :collection_uri, :title, :description
    
    attr_reader :accept, :accept_alternate_multipart_related
    attr_reader :sword_collection_policy, :sword_mediation, :sword_treatment
    
    attr_reader :sword_accept_packagings #[]
    attr_reader :sword_services #[]

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
      
    end #initialize
    
    def to_s
      "#{@title}: #{@description} #{@collection_uri}"

    end
  
    def resources(connection)
      puts connection.get(@collection_uri)

    end
    
    def create_resource
      
    end

  end  #class
end #module