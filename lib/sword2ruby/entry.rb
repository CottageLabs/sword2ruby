#entry.rb

require 'atom/entry'

module Sword2Ruby
  class Atom::Entry < Atom::Element
    
    def alternate_uri
      Utility.find_link_uri(links, "alternate")
    end
    
    def media_entry_uri
      Utility.find_link_uri(links, "edit")
    end

    def media_resource_links
      Utility.find_links_all_types(links, "edit-media")
    end

    def sword_edit_uri
      Utility.find_link_uri(links, "http://purl.org/net/sword/terms/add")
    end    
    
    def sword_original_deposit_uri
      Utility.find_link_uri(links, "http://purl.org/net/sword/terms/originalDeposit")
    end

    def sword_derived_resource_links
      Utility.find_links_all_types(links, "http://purl.org/net/sword/terms/derivedResource")
    end
   
    def sword_statement_links
      Utility.find_links_all_types(links, "http://purl.org/net/sword/terms/statement")
    end
    
    def sword_accept_packagings
      Utility.find_extensions_string(extensions, "sword:packaging")
    end
    
    def sword_treatment
      Utility.find_extension_string(extensions, "sword:treatment")
    end
    
    def sword_verbose_description
      Utility.find_extension_string(extensions, "sword:verboseDescription")
    end
    
    def dublin_core_extensions
      Utility.find_extensions_by_namespace(extensions, "http://purl.org/dc/terms/")
    end

    def add_dublin_core_extension! (name, value)
      extension = REXML::Element.new(name)
      extension.add_namespace("http://purl.org/dc/terms/")
      extension.text = value
      extensions << extension
    end
     
    def delete_dublin_core_extension! (name)
      extensions.delete_if {|e| e.namespace == "http://purl.org/dc/terms/" && e.name == name}
    end
    
    # Post a new entry to the sword-edit uri
    def post!(entry, alternative_sword_edit_uri = sword_edit_uri, in_progress = nil, on_behalf_of = nil, http = @http)
      alternative_sword_edit_uri ||= sword_edit_uri
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of
      response = http.post(alternative_sword_edit_uri, entry.to_s, headers)
      if response.is_a? Net::HTTPSuccess
        #        does return a DepositReceipt
        receipt = Atom::Entry.parse(response.body)
        receipt.http = @http
        return receipt
      else
        raise Sword2Ruby::Exception.new("Failed to do post!(): server returned code #{response.code} #{response.message}")
      end
    end
    
    def post_media!(filepath, content_type, packaging, alternative_media_resource_uri = media_resource_links.first.href, on_behalf_of = nil, metadata_relevant = nil, http = @http)
      #if a media_resource_uri has not been supplied, use the first one available for this entry
      alternative_media_resource_uri ||= media_resource_links.first.href      
      filename, md5, data = Utility.read_file(filepath)

      headers = {"Content-Type" => content_type}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = md5
      headers["Packaging"] = packaging
      headers["Metadata-Relevant"] = metadata_relevant.to_s.downcase if (metadata_relevant == true || metadata_relevant == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

      response = http.put(alternative_media_resource_uri, data, headers)

      if response.is_a? Net::HTTPSuccess
        return true #post_media!() does not return a DepositReceipt
      else
       raise Sword2Ruby::Exception.new("Failed to do post_media!(): server returned #{response.code} #{response.message}")
      end
    end
    
    def post_multipart!(entry, filepath, content_type, packaging, alternative_sword_edit_uri = sword_edit_uri, in_progress = nil, on_behalf_of = nil, metadata_relevant = nil, http = @http)
        tmp = ""
        boundary = "========" + Time.now.to_i.to_s + "=="
        filename, md5, data = Utility.read_file(filepath)
        alternative_sword_edit_uri ||= sword_edit_uri

        headers = {"Content-Type" => 'multipart/related; boundary="' + boundary + '"; type="application/atom+xml"'}
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
        tmp << "Metadata-Relevant: #{metadata_relevant.to_s.downcase}\r\n" if (metadata_relevant == true || metadata_relevant == false)
        tmp << "MIME-Version: 1.0\r\n\r\n"

        # write the file base64 encoded to temp
        tmp << Base64.encode64(data)

        # write boundary identifier to temp
        tmp << "--#{boundary}--\r\n" #The last two dashes (--) are important!

        response = http.post(alternative_sword_edit_uri, tmp, headers)

        if response.is_a? Net::HTTPSuccess
          #        does return a DepositReceipt
          receipt = Atom::Entry.parse(response.body)
          receipt.http = http
          return receipt
        else
          raise Sword2Ruby::Exception.new("Failed to do post_multipart!(): server returned #{response.code} #{response.message}")
        end
      end    
    
    # Put an updated entry
    def put!(alternative_media_entry_uri = media_entry_uri, in_progress = nil, on_behalf_of = nil, http = @http)
      alternative_media_entry_uri ||= media_entry_uri
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of
      response = http.post(alternative_media_entry_uri, self.to_s, headers)
      if response.is_a? Net::HTTPSuccess
        return true #Put() does not return a DepositReceipt
      else
        raise Sword2Ruby::Exception.new("Failed to do put!(): server returned code #{response.code} #{response.message}")
      end
    end

    def put_media!(filepath, content_type, packaging, alternative_media_resource_uri = media_resource_links.first.href, on_behalf_of = nil, metadata_relevant = nil, http = @http)
      #if a media_resource_uri has not been supplied, use the first one available for this entry
      alternative_media_resource_uri ||= media_resource_links.first.href      
      filename, md5, data = Utility.read_file(filepath)

      headers = {"Content-Type" => content_type}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = md5
      headers["Packaging"] = packaging
      headers["Metadata-Relevant"] = metadata_relevant.to_s.downcase if (metadata_relevant == true || metadata_relevant == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

      response = http.put(alternative_media_resource_uri, data, headers)

      if response.is_a? Net::HTTPSuccess
       return true #Put() does not return a DepositReceipt
      else
       raise Sword2Ruby::Exception.new("Failed to do put_media!(): server returned #{response.code} #{response.message}")
      end
    end
    
    
     def put_multipart!(filepath, content_type, packaging, alternative_media_entry_uri = media_entry_uri, in_progress = nil, on_behalf_of = nil, http = @http)
        tmp = ""
        boundary = "========" + Time.now.to_i.to_s + "=="
        filename, md5, data = Utility.read_file(filepath)
        alternative_media_entry_uri ||= media_entry_uri
        

        headers = {"Content-Type" => 'multipart/related; boundary="' + boundary + '"; type="application/atom+xml"'}
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
        tmp << self.to_s + "\r\n"

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

        response = http.post(alternative_media_entry_uri, tmp, headers)

        if response.is_a? Net::HTTPSuccess
          return true #Put() does not return a DepositReceipt
        else
          raise Sword2Ruby::Exception.new("Failed to do put_multipart!(): server returned #{response.code} #{response.message}")
        end
      end
      
      
      def delete!(alternative_media_entry_uri = media_entry_uri, on_behalf_of = nil, http = @http)
        alternative_media_entry_uri ||= media_entry_uri

        headers = {}
        headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

        response = http.delete(alternative_media_entry_uri, nil, headers)

        if response.is_a? Net::HTTPSuccess
         return true #delete() does not return a DepositReceipt
        else
         raise Sword2Ruby::Exception.new("Failed to do delete!(): server returned #{response.code} #{response.message}")
        end
      end
      
      
      def delete_media!(alternative_media_resource_uri = media_resource_links.first.href, on_behalf_of = nil, http = @http)
        #if a media_resource_uri has not been supplied, use the first one available for this entry
        alternative_media_resource_uri ||= media_resource_links.first.href
    
        headers = {}
        headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

        response = http.delete(alternative_media_resource_uri, nil, headers)

        if response.is_a? Net::HTTPSuccess
         return true #delete() does not return a DepositReceipt
        else
         raise Sword2Ruby::Exception.new("Failed to do delete_media!(): server returned #{response.code} #{response.message}")
        end
      end
      
        
  end
end