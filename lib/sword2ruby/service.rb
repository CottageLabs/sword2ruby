#service.rb
require 'uri'
require 'rexml/document'

module Sword2Ruby
  class Service
  
    attr_reader :service_document_uri
    attr_reader :service_document_source

    attr_reader :collections
    attr_reader :repository_name    
    attr_reader :sword_version, :sword_max_upload_size

#   :sword_verbose, :, :sword_no_op ?? not defined in sword spec
#, :sword_mediation



    def initialize(service_document_uri_string, connection)
      Utility.check_argument_class('service_document_uri_string', service_document_uri_string, String)
      Utility.check_argument_class('connection', connection, Connection)
      @service_document_uri = URI.parse(service_document_uri_string)
      reload_service_document(connection)
    end #initialize
    
    
    def reload_service_document(connection)
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
            
      #@sword_mediation = to_boolean(parser.service_properties[:sword_mediation])
      #@sword_verbose = parser.service_properties[:sword_verbose]
      #@sword_no_op = parser.service_properties[:sword_noOp]
    end


  end  #class
end #module