#collection.rb

require 'atom/collection'
require "base64"

module Sword2Ruby


  #Extensions to the atom-tools[https://github.com/bct/atom-tools/wiki] Atom::Collection class to support Sword2 operations.
  #These methods are additive to those supplied by the atom-tools gem.
  #
  #Please see the {atom-tools documentation}[http://rdoc.info/github/bct/atom-tools/master/frames] for a complete list of attributes and methods.
  class Atom::Collection < Atom::Element
    
    #Special sword_accepts to override usual accept
    elements ['app', ATOM_PUBLISHING_PROTOCOL_NAMESPACE], :accept, :sword_accepts, Sword2Ruby::SwordAccept

    #This method returns the string value of the <sword:collectionPolicy>[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_retreivingservicedocument],
    #or nil if it is not defined in the service document.
    def sword_collection_policy
      Utility.find_element_text(extensions, "sword:collectionPolicy")
    end

    #This method returns the boolean value of the <sword:mediation>[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_retreivingservicedocument] tag,
    #or false if it is not defined in the service document.    
    def sword_mediation
      Utility.find_element_boolean(extensions, "sword:mediation") || false
    end

    #This method returns the string value of the <sword:treatment>[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_retreivingservicedocument] tag,
    #or nil if it is not defined in the service document.
    def sword_treatment
      Utility.find_element_text(extensions, "sword:treatment")
    end
    
    #This method returns an array of the string values of the <sword:acceptPackaging>[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_retreivingservicedocument] tags,
    #or an empty array [ ] if none are defined in the service document.
    def sword_accept_packagings
      Utility.find_elements_text(extensions, "sword:acceptPackaging")
    end

    #This method returns an array of the string values of the <sword:service>[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_retreivingservicedocument] tags,
    #or an empty array [ ] if none are defined in the service document.
    def sword_services
      Utility.find_elements_text(extensions, "sword:service")
    end

    #This method returns the string value of the <app:accept>[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_retreivingservicedocument] tag,
    #or nil if it not defined in the service document.
    def app_accept
      sword_accepts.find{|a| a.alternate.nil? }
    end    

    #This method returns the string value of the <app:accept alternate="multipart-related">[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_retreivingservicedocument] tag,
    #or nil if it not defined in the service document.
    def app_accept_alternate_multipart_related
      sword_accepts.find{|a| a.alternate == "multipart-related" }
    end
    
    
    #This method creates a new entry in the collection by posting an Atom entry to the collection URI.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #entry:: an Atom::Entry to be added to the collection
    #slug:: (optional) the suggested identifier of the new entry
    #in_progress:: (optional) boolean value indicating whether the new entry will be completed at a later date
    #on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #
    #For more information, see the Sword2 specification: {section 6.3.3. "Creating a Resource with an Atom Entry"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_creatingresource_entry].
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
    

    #This method creates a new entry in the collection by posting a file to the collection URI.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #packaging:: the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #slug:: (optional) the suggested identifier of the new entry
    #in_progress:: (optional) boolean value indicating whether the new entry will be completed at a later date
    #on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #
    #For more information, see the Sword2 specification: {section 6.3.1. "Creating a Resource with a Binary File Deposit"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_creatingresource_binary].
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
    
   
    #This method creates a new entry in the collection by posting a file and atom-entry to the collection URI.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #entry:: an Atom::Entry to be added to the collection
    #filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #packaging:: the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #slug:: (optional) the suggested identifier of the new entry
    #in_progress:: (optional) boolean value indicating whether the new entry will be completed at a later date
    #on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #
    #For more information, see the Sword2 specification: {section 6.3.2. "Creating a Resource with a Multipart Deposit"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_creatingresource_multipart].
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