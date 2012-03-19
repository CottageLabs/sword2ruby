#auto_discover.rb

require 'open-uri'
require 'hpricot'

module Sword2Ruby
  class AutoDiscover
  
    attr_reader :service_document_uri, :deposit_endpoint_uri, :resource_edit_uris, :resource_statement_uris

    
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
    
    
    def get_attribute(item, attribute)
      if item.nil?
        return nil
      else
        return item[attribute]
      end  
    end
    
  end #class
end #module