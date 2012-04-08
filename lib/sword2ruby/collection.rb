require "base64"
require 'atom/element'
require 'atom/collection'


module Sword2Ruby


  #Extensions to the atom-tools[https://github.com/bct/atom-tools/wiki] Atom::Collection class to support Sword2 operations.
  #These methods are additive to those supplied by the atom-tools gem.
  #
  #Please see the {atom-tools documentation}[http://rdoc.info/github/bct/atom-tools/master/frames] for a complete list of attributes and methods.
  class ::Atom::Collection < ::Atom::Element
    
    #Special sword_accepts to override usual accept
    elements ['app', ATOM_PUBLISHING_PROTOCOL_NAMESPACE], :accept, :sword_accepts, Sword2Ruby::SwordAccept
    
    #This method returns the URI string from the @href attribute of the Collection,
    #or nil if it is not defined.
    def collection_uri
      @href
    end

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
    
    
#CRUD methods    
    
    #This method creates a new entry in the collection by posting an Atom entry to the collection URI.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #===Parameters (passed as a hash collection)
    #:entry:: an Atom::Entry to be added to the collection
    #:slug:: (optional) string value indicating the suggested identifier of the new entry
    #:collection_uri:: (optional) the collection URI to post to. If not supplied, this will default to the current collection's URI as specified in the @href attribute.
    #:in_progress:: (optional) boolean value indicating whether the new entry will be completed at a later date
    #:on_behalf_of:: (optional) string value indicating username on whos behalf the submission is being performed
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing collection's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.3.3. "Creating a Resource with an Atom Entry"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_creatingresource_entry].
    def post!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :entry => nil,
        :slug => nil,
        :collection_uri => collection_uri,
        :in_progress => nil,
        :on_behalf_of => nil,
        :connection => @http
      }
      options = defaults.merge(params)

      #Validate parameters
      Utility.check_argument_class(':entry', options[:entry], ::Atom::Entry)
      Utility.check_argument_class(':slug', options[:slug], String) if options[:slug]
      Utility.check_argument_class(':collection_uri', options[:collection_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
   
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["Slug"] = options[:slug] if options[:slug]
      headers["In-Progress"] = options[:in_progress].to_s.downcase if (options[:in_progress] == true || options[:in_progress] == false)
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]

      response = options[:connection].post(options[:collection_uri], options[:entry].to_s, headers)
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do post!(#{options[:collection_uri]}): server returned code #{response.code} #{response.message}")
      end
    end
    

    #This method creates a new entry in the collection by posting a file to the collection URI.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #===Parameters (passed as a hash collection)
    #:filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #:content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #:packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #:slug:: (optional) the suggested identifier of the new entry
    #:collection_uri:: (optional) the collection URI to post to. If not supplied, this will default to the current collection's URI as specified in the @href attribute.
    #:in_progress:: (optional) boolean value indicating whether the new entry will be completed at a later date
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing collection's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.3.1. "Creating a Resource with a Binary File Deposit"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_creatingresource_binary].
    def post_media!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :filepath => nil,
        :content_type => nil,
        :packaging => nil,
        :slug => nil,
        :collection_uri => collection_uri,
        :in_progress => nil,
        :on_behalf_of => nil,
        :connection => @http
      }
      options = defaults.merge(params)

      #Validate parameters
      Utility.check_argument_class(':filepath', options[:filepath], String)
      Utility.check_argument_class(':content_type', options[:content_type], String)
      Utility.check_argument_class(':packaging', options[:packaging], String) if options[:packaging]
      Utility.check_argument_class(':slug', options[:slug], String) if options[:slug]
      Utility.check_argument_class(':collection_uri', options[:collection_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
        
      filename, md5, data = Utility.read_file(options[:filepath])
      
      headers = {"Content-Type" => options[:content_type]}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = md5
      headers["Packaging"] = options[:packaging] if options[:packaging]
      headers["Slug"] = options[:slug] if options[:slug]
      headers["In-Progress"] = options[:in_progress].to_s.downcase if (options[:in_progress] == true || options[:in_progress] == false)
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]

      response = options[:connection].post(options[:collection_uri], data, headers)
      
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do post_media!(#{options[:collection_uri]}): server returned #{response.code} #{response.message}")
      end
    end
    
   
    #This method creates a new entry in the collection by posting a file and atom-entry to the collection URI.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #===Parameters (passed as a hash collection)
    #:entry:: an Atom::Entry to be added to the collection
    #:filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #:content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #:packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #:slug:: (optional) the suggested identifier of the new entry
    #:collection_uri:: (optional) the collection URI to post to. If not supplied, this will default to the current collection's URI as specified in the @href attribute.
    #:in_progress:: (optional) boolean value indicating whether the new entry will be completed at a later date
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing collection's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.3.2. "Creating a Resource with a Multipart Deposit"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_creatingresource_multipart].
    def post_multipart!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :entry => nil,
        :filepath => nil,
        :content_type => nil,
        :packaging => nil,
        :slug => nil,
        :collection_uri => collection_uri,        
        :in_progress => nil,
        :on_behalf_of => nil,
        :connection => @http
      }
      options = defaults.merge(params)

      #Validate parameters
      Utility.check_argument_class(':entry', options[:entry], ::Atom::Entry)
      Utility.check_argument_class(':filepath', options[:filepath], String)
      Utility.check_argument_class(':content_type', options[:content_type], String)
      Utility.check_argument_class(':packaging', options[:packaging], String) if options[:packaging]
      Utility.check_argument_class('slug', options[:slug], String) if options[:slug]
      Utility.check_argument_class(':collection_uri', options[:collection_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
            
      tmp = ""
      boundary = "========" + Time.now.to_i.to_s + "=="
      filename, md5, data = Utility.read_file(options[:filepath])

      headers = {"Content-Type" => 'multipart/related; boundary="' + boundary + '"; type="application/atom+xml"'}
      headers["Slug"] = options[:slug] if options[:slug]
      headers["In-Progress"] = options[:in_progress].to_s.downcase if (options[:in_progress] == true || options[:in_progress] == false)
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]
      headers["MIME-Version"] = "1.0"
      
      
      # write boundary identifer to temp
      tmp << "--#{boundary}\r\n"

      # write entry relevant headers to temp
      tmp << "Content-Type: application/atom+xml; charset=\"utf-8\"\r\n"
      tmp << "Content-Disposition: attachment; name=atom\r\n"
      tmp << "MIME-Version: 1.0\r\n\r\n"

      # write entry to temp
      tmp << options[:entry].to_s + "\r\n"
      
      # write boundary identifier to temp
      tmp << "--#{boundary}\r\n"

      # write media part relevant headers to temp      
      tmp << "Content-Type: #{options[:content_type]}\r\n"
      tmp << "Content-Disposition: attachment; name=payload; filename=#{filename}\r\n"
      tmp << "Content-MD5: #{md5}\r\n"
      tmp << "Packaging: #{options[:packaging]}\r\n" if options[:packaging]
      tmp << "MIME-Version: 1.0\r\n\r\n"
      
      # write the file base64 encoded to temp
      tmp << Base64.encode64(data)

      # write boundary identifier to temp
      tmp << "--#{boundary}--\r\n" #The last two dashes (--) are important!
      
      response = options[:connection].post(options[:collection_uri], tmp, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do post_multipart!(#{options[:collection_uri]}): server returned #{response.code} #{response.message}")
      end
    end
        
  end #class
end #module