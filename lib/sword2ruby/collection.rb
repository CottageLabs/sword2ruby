#collection.rb

require 'atom/collection'
require "base64"

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

      response = @http.post(@href, entry.to_s, headers)
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, @http)
      else
        raise Sword2Ruby::Exception.new("Failed to do post!(): server returned code #{response.code} #{response.message}")
      end
    end
    
    
    def post_media!(filepath, content_type, packaging, slug = nil, in_progress = nil, on_behalf_of = nil)
      filename, md5, data = Utility.read_file(filepath)
      
      headers = {"Content-Type" => content_type}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = md5
      headers["Packaging"] = packaging
      headers["Slug"] = slug if slug
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

      response = @http.post(@href, data, headers)
      
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, @http)
      else
        raise Sword2Ruby::Exception.new("Failed to do post_media!(): server returned #{response.code} #{response.message}")
      end
    end
    
   
    
    def post_multipart!(entry, filepath, content_type, packaging, slug = nil, in_progress = nil, on_behalf_of = nil)
      tmp = ""
      boundary = "========" + Time.now.to_i.to_s + "=="
      filename, md5, data = Utility.read_file(filepath)

      headers = {"Content-Type" => 'multipart/related; boundary="' + boundary + '"; type="application/atom+xml"'}
      headers["Slug"] = slug if slug
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of
      headers["MIME-Version"] = "1.0"
      
      
      # write boundary identifer to temp
      tmp << "--#{boundary}\r\n"

      # write entry relevant headers to temp
      tmp << "Content-Type: application/atom+xml; charset=\"utf-8\"\r\n"
      tmp << "Content-Disposition: attachment; name=atom\r\n"
      tmp << "MIME-Version: 1.0\r\n\r\n"

      # write entry to temp
      tmp << entry.to_s + "\r\n"
      
      # write boundary identifier to temp
      tmp << "--#{boundary}\r\n"

      # write media part relevant headers to temp      
      tmp << "Content-Type: #{content_type}\r\n"
      tmp << "Content-Disposition: attachment; name=payload; filename=#{filename}\r\n"
      tmp << "Content-MD5: #{md5}\r\n"
      tmp << "Packaging: #{packaging}\r\n" if packaging
      tmp << "MIME-Version: 1.0\r\n\r\n"
      
      # write the file base64 encoded to temp
      tmp << Base64.encode64(data)

      # write boundary identifier to temp
      tmp << "--#{boundary}--\r\n" #The last two dashes (--) are important!
      
      response = @http.post(@href, tmp, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, @http)
      else
        raise Sword2Ruby::Exception.new("Failed to do post_multipart!(): server returned #{response.code} #{response.message}")
      end
    end
        
  end #class
end #module