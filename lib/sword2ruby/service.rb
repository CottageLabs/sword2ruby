#service.rb
require 'uri'
require 'rexml/document'

module Sword2Ruby
  class Service < Refresh
    
    attr_reader :service_document_uri
    
    def service_document_source
      check_refreshed
      @service_document_source
    end

    def collections
      check_refreshed
      @collections
    end
    
    def repository_name
      check_refreshed
      @repository_name
    end
    
    def sword_version
      check_refreshed
      @sword_version
    end

    def sword_max_upload_size
      check_refreshed
      @sword_max_upload_size
    end

   
    

    def initialize(service_document_uri)
      if service_document_uri.is_a? URI
        @service_document_uri = service_document_uri
      else
        Utility.check_argument_class('service_document_uri', service_document_uri, String)        
        @service_document_uri = URI.parse(service_document_uri)
      end
      Utility.check_uri(@service_document_uri)
      
      super() #call Refresh.initialize()
    end #initialize
    
    def load(connection)
      refresh(connection)
    end
    
    def refresh(connection)
      Utility.check_argument_class('connection', connection, Connection)
      
      parser = ServiceDocumentParser.new()
      
      # use SAX Parsing with REXML
      @service_document_source = REXML::Source.new(connection.get(@service_document_uri))

      #parse Source Doc XML using custom parser
      REXML::Document.parse_stream(@service_document_source, parser)

      @sword_version = parser.service_properties[:sword_version]
      @sword_max_upload_size = parser.service_properties[:sword_maxUploadSize] ? parser.service_properties[:sword_maxUploadSize].to_i : nil
      @repository_name = parser.service_properties[:atom_title]
      
      @collections = parser.service_collections
      
      super() #call Refresh.refresh()
            
      #@sword_mediation = to_boolean(parser.service_properties[:sword_mediation])
      #@sword_verbose = parser.service_properties[:sword_verbose]
      #@sword_no_op = parser.service_properties[:sword_noOp]
    end


  end  #class
end #module