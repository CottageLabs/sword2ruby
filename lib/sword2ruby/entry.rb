require 'atom/entry'

module Sword2Ruby
  #Extensions to the atom-tools[https://github.com/bct/atom-tools/wiki] Atom::Entry class to support Sword2 operations.
  #These methods are additive to those supplied by the atom-tools gem.
  #
  #Please see the {atom-tools documentation}[http://rdoc.info/github/bct/atom-tools/master/frames] for a complete list of attributes and methods.
  class ::Atom::Entry < ::Atom::Element

#Deposit Receipt tags
    
    #This method returns the URI string of the <link rel="alternate"> tag (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined.
    def alternate_uri
      Utility.find_link_uri(links, "alternate")
    end

    #This method returns the URI string of the <b>\Atom \Entry Edit</b> <link rel="edit"> tag  (usually contained in the DepositReceipt Entry),
    #or nil if it is not defined. It is also known as the Media \Entry URI or Edit-URI.
    def entry_edit_uri #media_entry_uri
      Utility.find_link_uri(links, "edit")
    end
    alias :media_entry_uri :entry_edit_uri

    #This method returns an array of Atom::Links for the <b>\Atom Edit Media</b> <link rel="edit-media"> tags (usually contained in the DepositReceipt Entry),
    #or an empty array [ ] if none are defined. They are also known as the Media Resource URIs or EM-URIs.
    def edit_media_links #media_resource_links
      Utility.find_links_all_types(links, "edit-media")
    end
    alias :media_resource_links :edit_media_links

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
    #
    #For more information, see the {Dublin Core Metadata Terms specification}[http://dublincore.org/documents/dcmi-terms/].
    def dublin_core_extensions
      Utility.find_elements_by_namespace(extensions, "http://purl.org/dc/terms/")
    end

    #This method adds a new Dublin Core element to the entry,
    #===Parameters
    #name:: a valid Dublin Core Term Name, e.g. "abstract", "title" or "publisher" etc
    #value:: the string value of the new Dublin Core element, e.g. "A report on Burritos", "History of Burritos" or "Burrito King" etc
    #
    #For more information, see the {Dublin Core Metadata Terms specification}[http://dublincore.org/documents/dcmi-terms/].
    def add_dublin_core_extension!(name, value)
      extension = REXML::Element.new(name)
      extension.add_namespace("http://purl.org/dc/terms/")
      extension.text = value
      extensions << extension
    end

    #This method searches for the specified Dublin Core term in the entry and removes it where found.
    #===Parameters
    #name:: a valid Dublin Core Term Name, e.g. "isReferencedBy", "title" or "accrualPolicy" etc
    #
    #For more information, see the {Dublin Core Metadata Terms specification}[http://dublincore.org/documents/dcmi-terms/].
    def delete_dublin_core_extension!(name)
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
      
      
#CRUD methods
      
    #This method posts a new entry to an existing entry's sword-edit URI, adding to the existing entry's metadata (i.e. not overwriting existing metadata).
    #It <i>does not</i> create a new entry in the collection.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #===Parameters (passed as a hash collection)
    #:entry:: (optional) a new Atom::Entry with metadata to be added to an existing Atom::Entry. If not supplied, this will default to itself.
    #:\sword_edit_uri:: (optional) an override to the existing entry's sword-edit URI. If not supplied, this will default to the existing entry's sword-edit URI.
    #:in_progress:: (optional) boolean value indicating whether the existing entry will be completed at a later date.
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #===Example BROKEN
    # # feed = collection.feed    # assuming that you have retrieved a collection from the service document
    # # feed.update!              # get all the entry data
    # # existing_entry = feed.entries.first
    # additional_entry = Atom::Entry.new()
    # additional_entry.title = "The Improved Burrito"
    # additional_entry.summary = "Adding some extra metadata to the existing entry"
    # additional_entry.add_dublin_core_extension!("publisher", "Burrito King")
    # deposit_receipt = existing_entry.post!(:entry => additional_entry, :in_progress => true)
    # feed.updated! #flag that the feed has been updated
    # feed.update! #get the updates  
    #For more information, see the Sword2 specification: {section 6.7.2. "Adding New Metadata to a Container"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_addingcontent_metadata].
    def post!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :entry => self,
        :sword_edit_uri => sword_edit_uri,
        :in_progress => nil,
        :on_behalf_of => nil,
        :connection => @http
      }
      options = defaults.merge(params)
 
      #Validate parameters
      Utility.check_argument_class(':entry', options[:entry], ::Atom::Entry)
      Utility.check_argument_class(':sword_edit_uri', options[:sword_edit_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
            
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["In-Progress"] = options[:in_progress].to_s.downcase if (options[:in_progress] == true || options[:in_progress] == false)
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]
      response = options[:connection].post(options[:sword_edit_uri], options[:entry].to_s, headers)
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do post!(#{options[:sword_edit_uri]}): server returned code #{response.code} #{response.message}")
      end
    end

    #This method posts a file to an existing entry's edit-media URI, adding to the existing entry's media resources (i.e. not overwriting existing media resources).
    #It <i>does not</i> create a new entry in the collection.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #===Parameters (passed as a hash collection)
    #:filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #:content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #:packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #:\edit_media_uri:: (optional) an override to the existing entry's edit media URI (media resource URI). If not supplied, this will default to the existing entry's <b>first</b> edit media URI (as there can be multiple edit media URIs).
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #:metadata_relevant:: (optional) boolean value indicating whether the server should consider the file or package a potential source of metadata.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.7.1. "Adding Content to the Media Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_addingcontent_mediaresource].
    def post_media!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :filepath => nil,
        :content_type => nil,
        :packaging => nil,
        :edit_media_uri => edit_media_links.first.href,
        :on_behalf_of => nil,
        :metadata_relevant => nil,
        :connection => @http
      }
      options = defaults.merge(params)
      
      #Validate parameters
      Utility.check_argument_class(':filepath', options[:filepath], String)
      Utility.check_argument_class(':content_type', options[:content_type], String)
      Utility.check_argument_class(':packaging', options[:packaging], String) if options[:packaging]
      Utility.check_argument_class(':edit_media_uri', options[:edit_media_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
         
      filename, md5, data = Utility.read_file(options[:filepath])

      headers = {"Content-Type" => options[:content_type]}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = md5
      headers["Packaging"] = options[:packaging] if options[:packaging]
      headers["Metadata-Relevant"] = options[:metadata_relevant].to_s.downcase if (options[:metadata_relevant] == true || options[:metadata_relevant] == false)
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]

      response = options[:connection].post(options[:edit_media_uri], data, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
       raise Sword2Ruby::Exception.new("Failed to do post_media!(#{options[:edit_media_uri]}): server returned #{response.code} #{response.message}")
      end
    end

    
      
    #This method posts an entry and a file to an existing entry's sword-edit URI, adding to the existing entry's metadata and media resources  (i.e. not overwriting existing metadata and media resources).
    #It <i>does not</i> create a new entry in the collection.
    #An MD5-digest will be calculated automatically from the file and sent to the server with the request.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #===Parameters (passed as a hash collection)
    #:entry:: (optional) a new Atom::Entry with metadata to be added to an existing Atom::Entry. If not supplied, this will default to itself.
    #:filepath:: a filepath string indicating the file to be posted. The file must be readable by the process.
    #:content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #:packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #:\sword_edit_uri:: (optional) an override to the existing entry's sword edit URI. If not supplied, this will default to the existing entry's sword edit URI.
    #:in_progress:: (optional) boolean value indicating whether the existing entry will be completed at a later date.
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed
    #:metadata_relevant:: (optional) boolean value indicating whether the server should consider the file or package a potential source of metadata.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.7.3. "Adding Content to the Media Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_addingcontent_multipart].
    def post_multipart!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :entry => self,
        :filepath => nil,
        :content_type => nil,
        :packaging => nil,
        :sword_edit_uri => sword_edit_uri,
        :in_progress => nil,
        :on_behalf_of => nil,
        :metadata_relevant => nil,
        :connection => @http
      }
      options = defaults.merge(params)

      #Validate parameters
      Utility.check_argument_class(':entry', options[:entry], ::Atom::Entry)
      Utility.check_argument_class(':filepath', options[:filepath], String)
      Utility.check_argument_class(':content_type', options[:content_type], String)
      Utility.check_argument_class(':packaging', options[:packaging], String) if options[:packaging]
      Utility.check_argument_class(':sword_edit_uri', options[:sword_edit_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
    
      tmp = ""
      boundary = "========" + Time.now.to_i.to_s + "=="
      filename, md5, data = Utility.read_file(options[:filepath])
      

      headers = {"Content-Type" => 'multipart/related; boundary="' + boundary + '"; type="application/atom+xml"'}
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
      tmp << "Metadata-Relevant: #{options[:metadata_relevant].to_s.downcase}\r\n" if (options[:metadata_relevant] == true || options[:metadata_relevant] == false)
      tmp << "MIME-Version: 1.0\r\n\r\n"

      # write the file base64 encoded to temp
      tmp << Base64.encode64(data)

      # write boundary identifier to temp
      tmp << "--#{boundary}--\r\n" #The last two dashes (--) are important!

      response = options[:connection].post(options[:sword_edit_uri], tmp, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do post_multipart!(#{options[:sword_edit_uri]}): server returned #{response.code} #{response.message}")
      end
    end
    

    #This method replaces an existing entry's metadata by performing a Put on the entry-edit URI.
    #It <i>does not</i> create a new entry in the collection.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #
    #===Example
    # feed = collection.feed    # assuming that you have retrieved a collection from the service document
    # feed.update!              # get all the entry data
    # existing_entry = feed.entries.first
    # existing_entry.title = "The Improved Burrito"
    # existing_entry.summary = "Replacing the metadata of an existing entry"
    # existing_entry.add_dublin_core_extension!("publisher", "Burrito King")
    # existing_entry.put!
    #
    #===Parameters (passed as a hash collection)
    #:entry:: (optional) a new Atom::Entry with metadata to replace an existing Atom::Entry. If not supplied, this will default to itself.
    #:entry_edit_uri:: (optional) an override to the existing entry's entry-edit URI. If not supplied, this will default to the existing entry's entry-edit URI.
    #:in_progress:: (optional) boolean value indicating whether the existing entry will be completed at a later date.
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.5.2. "Replacing the Metadata of a Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_editingcontent_metadata].
    def put!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :entry => self,
        :entry_edit_uri => entry_edit_uri,
        :in_progress => nil,
        :on_behalf_of => nil,
        :connection => @http
      }
      options = defaults.merge(params)
 
      #Validate parameters
      Utility.check_argument_class(':entry', options[:entry], ::Atom::Entry)
      Utility.check_argument_class(':entry_edit_uri', options[:entry_edit_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
            
      headers = {"Content-Type" => "application/atom+xml;type=entry" }
      headers["In-Progress"] = options[:in_progress].to_s.downcase if (options[:in_progress] == true || options[:in_progress] == false)
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]
      response = options[:connection].put(options[:entry_edit_uri], options[:entry].to_s, headers)
      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do put!(#{options[:entry_edit_uri]}): server returned code #{response.code} #{response.message}")
      end
    end
    

    #This method replaces an existing entry's file content of a resource by performing a Put on the edit-media URI.
    #It <i>does not</i> create a new entry in the collection.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #
    #===Parameters (passed as a hash collection)
    #:filepath:: a filepath string indicating the file to be sent. The file must be readable by the process.
    #:content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #:packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #:edit_media_uri:: (optional) an override to the existing entry's edit-media URI. If not supplied, this will default to the existing entry's first edit-media URI.
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed.
    #:metadata_relevant:: (optional) boolean value indicating whether the server should consider the file or package a potential source of metadata.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.5.1. "Replacing the File Content of a Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_editingcontent_binary].
    def put_media!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :filepath => nil,
        :content_type => nil,
        :packaging => nil,
        :edit_media_uri => edit_media_links.first.href,
        :on_behalf_of => nil,
        :metadata_relevant => nil,
        :connection => @http
      }
      options = defaults.merge(params)
      
      #Validate parameters
      Utility.check_argument_class(':filepath', options[:filepath], String)
      Utility.check_argument_class(':content_type', options[:content_type], String)
      Utility.check_argument_class(':packaging', options[:packaging], String) if options[:packaging]
      Utility.check_argument_class(':edit_media_uri', options[:edit_media_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)
      
      filename, md5, data = Utility.read_file(filepath)

      headers = {"Content-Type" => options[:content_type]}
      headers["Content-Disposition"] = "attachment; filename=#{filename}"
      headers["Content-MD5"] = md5
      headers["Packaging"] = options[:packaging] if options[:packaging]
      headers["Metadata-Relevant"] = options[:metadata_relevant].to_s.downcase if (options[:metadata_relevant] == true || options[:metadata_relevant] == false)
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]

      response = options[:connection].put(options[:edit_media_uri], data, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
       raise Sword2Ruby::Exception.new("Failed to do put_media!(#{options[:edit_media_uri]}): server returned #{response.code} #{response.message}")
      end
    end
    
    
    
    #This method replaces an existing entry's metadata and file content of a resource by performing a Put on the entry-edit URI.
    #It <i>does not</i> create a new entry in the collection.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #
    #===Parameters (passed as a hash collection)
    #:entry:: (optional) a new Atom::Entry with metadata to replace an existing Atom::Entry. If not supplied, this will default to itself.
    #:filepath:: a filepath string indicating the file to be sent. The file must be readable by the process.
    #:content_type:: the mime content-type string of the file, e.g. "application/zip" or "text/plain"
    #:packaging:: (optional) the Sword packaging string of the file, e.g. "http://purl.org/net/sword/package/METSDSpaceSIP"
    #:entry_edit_uri:: (optional) an override to the existing entry's entry-edit URI. If not supplied, this will default to the existing entry's entry-edit URI.
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed.
    #:metadata_relevant:: (optional) boolean value indicating whether the server should consider the file or package a potential source of metadata.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.5.3. "Replacing the Metadata and File Content of a Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_editingcontent_multipart].
    def put_multipart!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :entry => self,
        :filepath => nil,
        :content_type => nil,
        :packaging => nil,
        :entry_edit_uri => entry_edit_uri,
        :in_progress => nil,
        :on_behalf_of => nil,
        :metadata_relevant => nil,
        :connection => @http
      }
      options = defaults.merge(params)

      #Validate parameters
      Utility.check_argument_class(':entry', options[:entry], ::Atom::Entry)
      Utility.check_argument_class(':filepath', options[:filepath], String)
      Utility.check_argument_class(':content_type', options[:content_type], String)
      Utility.check_argument_class(':packaging', options[:packaging], String) if options[:packaging]
      Utility.check_argument_class(':entry_edit_uri', options[:entry_edit_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)

      tmp = ""
      boundary = "========" + Time.now.to_i.to_s + "=="
      filename, md5, data = Utility.read_file(options[:filepath])

      
      headers = {"Content-Type" => 'multipart/related; boundary="' + boundary + '"; type="application/atom+xml"'}
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

      response = options[:connection].put(options[:entry_edit_uri], tmp, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do put_multipart!(#{options[:entry_edit_uri]}): server returned #{response.code} #{response.message}")
      end
    end
      

    #This method removes the container by performing a Delete on the entry-edit URI.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #
    #===Parameters (passed as a hash collection)
    #:entry_edit_uri:: (optional) an override to the existing entry's entry-edit URI. If not supplied, this will default to the existing entry's entry-edit URI.
    #:on_behalf_of:: (optional) username on whos behalf the operation is being performed.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.8. "Deleting the Container"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_deleteconteiner].
    def delete!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :entry_edit_uri => entry_edit_uri,
        :on_behalf_of => nil,
        :connection => @http
      }
      options = defaults.merge(params)

      #Validate parameters
      Utility.check_argument_class(':entry_edit_uri', options[:entry_edit_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)

      headers = {}
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]

      response = options[:connection].delete(options[:entry_edit_uri], nil, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
       raise Sword2Ruby::Exception.new("Failed to do delete!(#{options[:entry_edit_uri]}): server returned #{response.code} #{response.message}")
      end
    end
      

    #This method removes all the content of a resource (without removing the resource itself) by performing a Delete on the edit-media URI.
    #The method will return a Sword2Ruby::DepositReceipt object, or raise a Sword2Ruby::Exception in the case of an error.
    #
    #===Parameters (passed as a hash collection)
    #:edit_media_uri:: (optional) an override to the existing entry's edit-media URI. If not supplied, this will default to the existing entry's first edit-media URI.
    #:on_behalf_of:: (optional) username on whos behalf the submission is being performed.
    #:connection:: (optional) Sword2Ruby::Connection object used to perform the operation. If not supplied, the existing entry's connection will be used.
    #Note that you should call <b><collection>.feed.updated!</b> followed by <b><collection>.feed.update!</b> after making updates to a collection.
    #
    #For more information, see the Sword2 specification: {section 6.6. "Deleting the content of a Resource"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#protocoloperations_deletingcontent].      
    def delete_media!(params = {})
      Utility.check_argument_class('params', params, Hash)
      defaults = {
        :edit_media_uri => edit_media_links.first.href,
        :on_behalf_of => nil,
        :connection => @http
      }
      options = defaults.merge(params)

      #Validate parameters
      Utility.check_argument_class(':edit_media_uri', options[:edit_media_uri], String)
      Utility.check_argument_class(':on_behalf_of', options[:on_behalf_of], String) if options[:on_behalf_of]
      Utility.check_argument_class(':connection', options[:connection], Sword2Ruby::Connection)

      headers = {}
      headers["On-Behalf-Of"] = options[:on_behalf_of] if options[:on_behalf_of]

      response = options[:connection].delete(options[:edit_media_uri], nil, headers)

      if response.is_a? Net::HTTPSuccess
        return DepositReceipt.new(response, options[:connection])
      else
        raise Sword2Ruby::Exception.new("Failed to do delete_media!(#{options[:edit_media_uri]}): server returned #{response.code} #{response.message}")
      end
    end
    
        
  end
end