require 'open-uri'
require 'hpricot'

module Sword2Ruby
  #AutoDiscover requires the hpricot[https://github.com/hpricot/hpricot/wiki] gem.
  class AutoDiscover
  
    #The Deposit Endpoint URI string discovered in the HTML document, or nil if it could not be discovered.
    #
    #For more information, see the Sword2 specification: {section 13.2. "For Deposit Endpoints"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#autodiscovery_deposit].
    attr_reader :deposit_endpoint_uri

    #An array of Atom Entry Edit URI strings discovered in the HTML document, or an empty array [ ] if none found.
    #
    #For more information, see the Sword2 specification: {section 13.3. "For Resources"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#autodiscovery_resources].
    attr_reader :resource_edit_uris

    #An array of Sword Statement URI strings discovered in the HTML document, or an empty array [ ] if none found.
    #
    #For more information, see the Sword2 specification: {section 13.3. "For Resources"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#autodiscovery_resources].    
    attr_reader :resource_statement_uris

    #The Service Document URI string discovered in the HTML document, or nil if it could not be discovered.
    #
    #For more information, see the Sword2 specification: {section 13.1. "For Service Documents"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#autodiscovery_servicedocuments].
    attr_reader :service_document_uri
    
    #Perform an Auto-Discovery on the URI supplied (which should point to an html document). 
    #The document will be retreived and parsed using hpricot.
    #Service Document, Deposit Endpoint and Resource URIs will be extracted where identified.
    #
    #For more information, see the Sword2 specification: {section 13 "Auto-Discovery"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#autodiscovery].
    def initialize(discover_uri)
      doc = Hpricot(open(discover_uri))
      
      @service_document_uri = get_attribute(doc.at("//link[@rel='http://purl.org/net/sword/discovery/service-document']"), "href")
      @service_document_uri ||= get_attribute(doc.at("//link[@rel='sword']"), "href") #Old sword 1.3
      
      @deposit_endpoint_uri = get_attribute(doc.at("//link[@rel='http://purl.org/net/sword/terms/deposit']"), "href")
      
      @resource_edit_uris = []
      @resource_statement_uris = []
      
      doc.search("//link[@rel='http://purl.org/net/sword/terms/edit']").each do |e|
        @resource_edit_uris << {:href => get_attribute(e, "href"), :type=> get_attribute(e, "type")}
      end
      
      doc.search("//link[@rel='http://purl.org/net/sword/terms/statement']").each do |e|
        @resource_statement_uris << {:href => get_attribute(e, "href"), :type=> get_attribute(e, "type")}
      end
    end
    
  
  private
    def get_attribute(item, attribute)
      if item.nil?
        return nil
      else
        return item[attribute]
      end  
    end
    
  end #class
end #module