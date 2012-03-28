#entry.rb

require 'atom/entry'

module Sword2Ruby
  #Extensions to the atom-tools[https://github.com/bct/atom-tools/wiki] Atom::Entry class to support Sword2 operations.
  #These methods are additive to those supplied by the atom-tools gem.
  #
  #Please see the {atom-tools documentation}[http://rdoc.info/github/bct/atom-tools/master/frames] for a complete list of attributes and methods.
  class Atom::Entry < Atom::Element

#Deposit Receipt tags
    
    #This method returns the URI string of the <link rel="alternate"> tag (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined.
    def alternate_uri
      Utility.find_link_uri(links, "alternate")
    end

    #This method returns the URI string of the <b>\Atom \Entry Edit</b> <link rel="edit"> tag  (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined. It is also known as the Media Entry URI or Edit-URI.
    def entry_edit_uri #media_entry_uri
      Utility.find_link_uri(links, "edit")
    end
    alias :media_entry_uri :entry_edit_uri
    alias :edit_uri :entry_edit_uri

    #This method returns an array of Atom::Links for the <b>Edit Media</b> <link rel="edit-media"> tags (usually contained in the DepositReceipt Entry),
    #or an empty array [ ] if none are defined. It is also known as the Media Resource URI or EM-URI.
    def edit_media_links
      Utility.find_links_all_types(links, "edit-media")
    end
    media_resource_links

    #This method returns the URI string of the <b>sword edit</b> <link rel="http://purl.org/net/sword/terms/add"> tag (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined.
    def sword_edit_uri
      Utility.find_link_uri(links, "http://purl.org/net/sword/terms/add")
    end    

    #This method returns the URI string of the package or file deposited, as specified in the <link rel="http://purl.org/net/sword/terms/originalDeposit"> tag (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined.    
    def sword_original_deposit_uri
      Utility.find_link_uri(links, "http://purl.org/net/sword/terms/originalDeposit")
    end

    #This method returns an array of Atom::Links for the <b>derived resource</b> <link rel="http://purl.org/net/sword/terms/derivedResource"> tags (usually contained in the DepositReceipt Entry),
    #or an empty array [ ] if none are defined.
    def sword_derived_resource_links
      Utility.find_links_all_types(links, "http://purl.org/net/sword/terms/derivedResource")
    end
    
    #This method returns an array of Atom::Links for the <b>sword statements</b>, from the <link rel="http://purl.org/net/sword/terms/statement"> tags (usually contained in the DepositReceipt Entry),
    #or an empty array [ ] if none are defined.
    def sword_statement_links
      Utility.find_links_all_types(links, "http://purl.org/net/sword/terms/statement")
    end
    
    #This method returns an array of string values for the <b>sword packagings</b>, from the <sword:packaging> tags (usually contained in the DepositReceipt Entry),
    #or an empty array [ ] if none are defined.
    def sword_packagings
      Utility.find_elements_text(extensions, "sword:packaging")
    end
    
    #This method returns the string value of the <b>sword treatment</b> <sword:treatment> tag (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined.
    def sword_treatment
      Utility.find_element_text(extensions, "sword:treatment")
    end

    #This method returns the string value of the <b>sword verbose description</b> <sword:verboseDescription> tag (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined.    
    def sword_verbose_description
      Utility.find_element_text(extensions, "sword:verboseDescription")
    end

    #This method returns an array of the Dublin Core elements (usually contained in the DepositReceipt Entry),
    #or an empty array [ ] if none are defined.
    def dublin_core_extensions
      Utility.find_elements_by_namespace(extensions, "http://purl.org/dc/terms/")
    end

    #This method adds a new Dublin Core element to the entry,
    #name:: a valid Dublin Core Term Name, e.g. "abstract", "title" or "publisher" etc
    #value:: the string value of the new Dublin Core element, e.g. "A report on Burritos", "History of Burritos" or "Burrito King" etc
    #
    #For more information, see the {Dublin Core Metadata Terms specification}[http://dublincore.org/documents/dcmi-terms/].
    def add_dublin_core_extension! (name, value)
      extension = REXML::Element.new(name)
      extension.add_namespace("http://purl.org/dc/terms/")
      extension.text = value
      extensions << extension
    end

    #This method searches for the specified Dublin Core term in the entry and removes it where found.
    #name:: a valid Dublin Core Term Name, e.g. "isReferencedBy", "title" or "accrualPolicy" etc
    def delete_dublin_core_extension! (name)
      extensions.delete_if {|e| e.namespace == "http://purl.org/dc/terms/" && e.name == name}
    end
    



#Sword Statement tags
    
    #This method returns the time value of the <sword:depositedOn> tag (usually contained in the Sword Statement Atom Feed),
    #or nil if it is not defined.
    def sword_deposited_on
      Utility.find_element_time(extensions, "sword:depositedOn")
    end

    #This method returns the string value of the <sword:depositedBy> tag (usually contained in the Sword Statement Atom Feed),
    #or nil if it is not defined.
    def sword_deposited_by
      Utility.find_element_text(extensions, "sword:depositedBy")
    end

    #This method returns the string value of the <sword:depositedOnBehalfOf> tag (usually contained in the Sword Statement Atom Feed),
    #or nil if it is not defined.
    def sword_deposited_on_behalf_of
      Utility.find_element_text(extensions, "sword:depositedOnBehalfOf")
    end
    
    #This method returns the Atom::Category of the original deposit (usually contained in the Sword Statement Atom Feed),
    #or nil if it is not defined.
    def sword_original_deposit_category
      Utility.find_element_by_scheme_and_term(categories, "http://purl.org/net/sword/terms/", "http://purl.org/net/sword/terms/originalDeposit")
    end
      
    #This method posts a new entry to an existing entry's sword-edit URI, adding to the existing entry's metadata (i.e. not overwriting existing metadata).
    #It <i>does not</i> create a new entry in the collection.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #
    #For example:
    #
    # feed = collection.feed    # assuming that you have retrieved a collection from the service document
    # feed.update!              # get all the entry data
    # existing_entry = feed.entries.first
    # additional_entry = Atom::Entry.new()
    # additional_entry.title = "The Improved Burrito"
    # additional_entry.summary = "Adding some extra metadata to the existing entry"
    # additional_entry.add_dublin_core_extension!("publisher", "Burrito King")
    # existing_entry.post!(additional_entry)
    #
    #entry:: a new Atom::Entry with metadata to be added to an existing Atom::Entry.
    #alternative_sword_edit_uri:: (optional) an override to the existing entry's sword-edit URI. If not supplied, this will default to the existing entry's sword-edit URI.
    #in_progress:: (optional) boolean value indicating whether the existing entry will be completed at a later date.
    #on_behalf_of:: (optional) username on whos behalf the submission is being performed.
    #http:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #
    #For more information, see the Sword2 specification: {section 6.7.2. "Adding New Metadata to a Container"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_addingcontent_metadata].
    def post!(entry, alternative_sword_edit_uri = sword_edit_uri, in_progress = nil, on_behalf_of = nil, http = @http)
      alternative_sword_edit_uri ||= sword_edit_uri
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of
      response = http.post(alternative_sword_edit_uri, entry.to_s, headers)
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, http)
      else
        raise Sword2Ruby::Exception.new("Failed to do post!(): server returned code #{response.code} #{response.message}")
      end
    end

    #This method posts a file to an existing entry's edit-media URI, adding to the existing entry's media resources (i.e. not overwriting existing media resources).
    #It <i>does not</i> create a new entry in the collection.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #alternative_media_resource_uri:: (optional) an override to the existing entry's media resource URI. If not supplied, this will default to the existing entry's <b>first</b> media resource URI (as there can be multiple media resource URIs).
    #on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #metadata_relevant:: (optional) boolean value indicating whether the server should consider the file or package a potential source of metadata.
    #http:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #
    #For more information, see the Sword2 specification: {section 6.7.1. "Adding Content to the Media Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_addingcontent_mediaresource].
    def post_media!(filepath, content_type, packaging = nil, alternative_media_resource_uri = media_resource_links.first.href, on_behalf_of = nil, metadata_relevant = nil, http = @http)
      #if a media_resource_uri has not been supplied, use the first one available for this entry
      alternative_media_resource_uri ||= media_resource_links.first.href      
      filename, md5, data = Utility.read_file(filepath)

      headers = {"Content-Type" => content_type}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = md5
      headers["Packaging"] = packaging if packaging
      headers["Metadata-Relevant"] = metadata_relevant.to_s.downcase if (metadata_relevant == true || metadata_relevant == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of

      response = http.put(alternative_media_resource_uri, data, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, http)
      else
       raise Sword2Ruby::Exception.new("Failed to do post_media!(): server returned #{response.code} #{response.message}")
      end
    end

    
      
    #This method posts an entry and a file to an existing entry's sword-edit URI, adding to the existing entry's metadata and media resources  (i.e. not overwriting existing metadata and media resources).
    #It <i>does not</i> create a new entry in the collection.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #entry:: a new Atom::Entry with metadata to be added to an existing Atom::Entry.
    #filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #alternative_sword_edit_uri:: (optional) an override to the existing entry's sword edit URI. If not supplied, this will default to the existing entry's sword edit URI.
    #in_progress:: (optional) boolean value indicating whether the existing entry will be completed at a later date.
    #on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #metadata_relevant:: (optional) boolean value indicating whether the server should consider the file or package a potential source of metadata.
    #http:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #
    #For more information, see the Sword2 specification: {section 6.7.3. "Adding Content to the Media Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_addingcontent_multipart].
    def post_multipart!(entry, filepath, content_type, packaging = nil, alternative_sword_edit_uri = sword_edit_uri, in_progress = nil, on_behalf_of = nil, metadata_relevant = nil, http = @http)
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
          return DepositReceipt.new(response, http)
        else
          raise Sword2Ruby::Exception.new("Failed to do post_multipart!(): server returned #{response.code} #{response.message}")
        end
      end    
    

    #This method puts an update an existing entry's sword-edit URI, adding to the existing entry's metadata (i.e. not overwriting existing metadata).
    #It <i>does not</i> create a new entry in the collection.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #
    #For example:
    #
    # feed = collection.feed    # assuming that you have retrieved a collection from the service document
    # feed.update!              # get all the entry data
    # existing_entry = feed.entries.first
    # additional_entry = Atom::Entry.new()
    # additional_entry.title = "The Improved Burrito"
    # additional_entry.summary = "Adding some extra metadata to the existing entry"
    # additional_entry.add_dublin_core_extension!("publisher", "Burrito King")
    # existing_entry.post!(additional_entry)
    #
    #entry:: a new Atom::Entry with metadata to be added to an existing Atom::Entry.
    #alternative_sword_edit_uri:: (optional) an override to the existing entry's sword-edit URI. If not supplied, this will default to the existing entry's sword-edit URI.
    #in_progress:: (optional) boolean value indicating whether the existing entry will be completed at a later date.
    #on_behalf_of:: (optional) username on whos behalf the submission is being performed.
    #http:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #
    #For more information, see the Sword2 specification: {section 6.7.2. "Adding New Metadata to a Container"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_addingcontent_metadata].
    def put!(alternative_media_entry_uri = media_entry_uri, in_progress = nil, on_behalf_of = nil, http = @http)
      alternative_media_entry_uri ||= media_entry_uri
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["In-Progress"] = in_progress.to_s.downcase if (in_progress == true || in_progress == false)
      headers["On-Behalf-Of"] = on_behalf_of if on_behalf_of
      response = http.post(alternative_media_entry_uri, self.to_s, headers)
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, http)
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
        return DepositReceipt.new(response, http)
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
          return DepositReceipt.new(response, http)
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
          return DepositReceipt.new(response, http)
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
          return DepositReceipt.new(response, http)
        else
          raise Sword2Ruby::Exception.new("Failed to do delete_media!(): server returned #{response.code} #{response.message}")
        end
      end
      
        
  end
end