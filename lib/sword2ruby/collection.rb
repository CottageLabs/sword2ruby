#collection.rb

require 'atom/collection'
require 'digest/md5'

module Sword2Ruby
  
  #Special class to override the usual <accept>s class
  class Atom::SwordAccept < Atom::Text
    is_element PP_NS, :accept
    attrb PP_NS, :alternate
  end
  
  class Atom::Collection < Atom::Element
    
    #Special sword_accepts to override usual accept
    elements ['app', PP_NS], :accept, :sword_accepts, Atom::SwordAccept

    def sword_collection_policy
      Utility.find_extension_string(extensions, "sword:collectionPolicy")
    end
    
    def sword_mediation
      #Sword spec requires assumption of False if sword:mediation is not returned
      Utility.find_extension_boolean(extensions, "sword:mediation") || false
    end
    
    def sword_treatment
      Utility.find_extension_string(extensions, "sword:treatment")
    end
    
    def sword_accept_packagings
      Utility.find_extensions_string(extensions, "sword:acceptPackaging")
    end

    def sword_services
      Utility.find_extensions_string(extensions, "sword:service")
    end

    def accept
      sword_accepts.find{|a| a.alternate.nil? }
    end    
    
    def accept_alternate_multipart_related
      sword_accepts.find{|a| a.alternate == "multipart-related" }
    end
    
   # POST an entry to the collection, with an optional slug
    def post!(entry, slug = nil, in_progress = nil, on_behalf_of = nil)
      Utility.check_argument_class('entry', entry, Atom::Entry)
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["Slug"] = slug if slug
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

      @http.post(@href, entry.to_s, headers)
    end
    
    def post_media!(data, filename, content_type, packaging, slug = nil, in_progress = nil, on_behalf_of = nil)
      headers = {"Content-Type" => content_type}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = Digest::MD5.hexdigest(data)
      headers["Packaging"] = packaging
      headers["Slug"] = slug if slug
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

      @http.post(@href, data, headers)
    end

  end #class
  
end #module