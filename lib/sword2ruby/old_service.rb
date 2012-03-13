#service.rb
require 'uri'
require 'atom/service'
#require 'rexml/document'

require "uri"

require "atom/http"
require "atom/element"
require "atom/collection"


module Sword2Ruby
  class OldService < Refresh
    
    attr_reader :service_document_uri
    
    def service_document
      check_refreshed
      @service_document
    end
    
    def collections
      service_document.collections
    end

    def workspaces
      service_document.workspaces
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
      Utility.check_argument_class('service_document_uri', service_document_uri, String)
      Utility.check_uri(service_document_uri)
      @service_document_uri = service_document_uri
      super() #initialise Refresh
    end
    

    def load(connection)
      refresh(connection)
    end
    
    def refresh(connection)
      Utility.check_argument_class('connection', connection, Connection)
      @service_document = Atom::Service.new(@service_document_uri, connection)
      
      tmp = @service_document.extensions.find{|e| e.fully_expanded_name=="sword:version"}
      @sword_version = tmp.nil? ? nil : tmp.text
      tmp = @service_document.extensions.find{|e| e.fully_expanded_name=="sword:maxUploadSize"}
      @sword_max_upload_size = tmp.nil? ? nil : tmp.text.to_i
      
      super() #call Refresh.refresh()
    end
   



     #      xml = @service_document.to_xml      
     #      xml.root.elements.each("sword:version"){|e| @sword_version = e.text.to_s}
     #      xml.root.elements.each("sword:version"){|e| @sword_version = e.text.to_s}



    #If accessing an unknown property of this resource, send it on to the service_document instead
#    def method_missing(name, *args, &block)
#      service_document.send(name, *args, &block)
#    end


    
=begin    
    
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
      Utility.check_argument_class('service_document_uri', service_document_uri, String)
      @service_document_uri = service_document_uri
      Utility.check_uri(@service_document_uri)
      super() #call Refresh.initialize()
    end #initialize
    
    def load(connection)
      refresh(connection)
    end
    
    def refresh(connection)
      Utility.check_argument_class('connection', connection, Connection)
      @service_document_source = Atom::Service.new(@service_document_uri, connection)
            
    end

=end
=begin
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
=end

  end  #class
end #module