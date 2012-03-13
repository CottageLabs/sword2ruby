#service.rb

require 'atom/service'

module Sword2Ruby
  
  #Extend existing Atom::Service with Sword methods
  class Atom::Service < Atom::Element
    
    def service_document_uri
      base
    end
    
    def sword_version
      Utility.find_extension_string(extensions, "sword:version")
    end
     
    def sword_max_upload_size
      Utility.find_extension_integer(extensions, "sword:maxUploadSize")
    end
    
    # retrieves and parses an Atom service document.
    def initialize(service_url = "", http = Atom::HTTP.new)
      super()

      @http = http

      return if service_url.empty?

      base = URI.parse(service_url)

      rxml = nil

      res = @http.get(base, "Accept" => "application/atomsvc+xml")
      res.validate_content_type(["application/atomsvc+xml"])

      unless res.code == "200"
        raise Atom::HTTPException, "Unexpected HTTP response code: #{res.code}"
      end

      service = self.class.parse(res.body, base, self)

      #Update workspaces, collections and their feeds to use the Service's http connection
      #Unfortunately this is necessary because the atom-tools library does not propagate the
      #http connection object from Service to Workspace
      set_http(http)

      service
    end
    
    
    private
    def set_http(http)
      workspaces.each do |w|
        w.http = http
        w.collections.each do |c|
          c.http = http
          c.feed.http = http
        end
      end
    end 
   
  end #class
end #module