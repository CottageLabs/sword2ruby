#test_spec.rb

require 'test_constants'


describe Atom::Service do
  
  it "Testing Service" do

    puts "\ntesting Atom::Service"
    
    service = Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID, TEST_CONNECTION_VALID);
    
    puts "service.service_document_uri: #{service.service_document_uri}"
    puts "service.sword_version: #{service.sword_version}"
    puts "service.sword_max_upload_size: #{service.sword_max_upload_size}"    
    puts "service.workspaces.count: #{service.workspaces.count}"

    workspace = service.workspaces.first
    puts "workspace.title: #{workspace.title}"
    puts "workspace.collections.count: #{service.collections.count}"

    collection = workspace.collections.last #.find{|c| c.href=="http://localhost:8080/col-uri/14661f1f-e625-4145-b477-2b08b757c6d7"}
    puts "collection.title: #{collection.title}"
    puts "collection.href: #{collection.href}"
    puts "collection.sword_collection_policy: #{collection.sword_collection_policy}"
    puts "collection.sword_mediation: #{collection.sword_mediation}"
    puts "collection.sword_treatment: #{collection.sword_treatment}"
    puts "collection.sword_accept_packagings: #{collection.sword_accept_packagings}"
    puts "collection.sword_services: #{collection.sword_services}"
    puts "collection.accepts: #{collection.accepts}"
    puts "collection.accept: #{collection.accept}"
    puts "collection.accept_alternate_multipart_related: #{collection.accept_alternate_multipart_related}"

    feed = collection.feed
    feed.update!
    puts "feed.title: #{feed.title}"
    puts "feed.subtitle: #{feed.subtitle}"
    puts "feed.id: #{feed.id}"
    puts "feed.generator: #{feed.generator}"
    puts "feed.rights: #{feed.rights}"
    puts "feed.entries.count: #{feed.entries.count}"
    puts "feed.links.count: #{feed.links.count}"

    puts "\n"  

    puts "creating a new entry (post atom)"
    entry = feed.entries.new()
    entry.title = "Martyns new entry created on #{Time.now}"
    entry.summary = "This is a test"
    entry.updated = Time.now
    entry.add_dublin_core_extension!("publisher", "Nature Publishing")

    deposit_receipt = collection.post!(entry)
    
    puts "deposit_receipt.location = #{deposit_receipt.location}"
    puts "deposit_receipt.status_code = #{deposit_receipt.status_code}"
    puts "deposit_receipt.status_message = #{deposit_receipt.status_message}"
    puts "deposit_receipt.entry.alternate_uri:\t #{deposit_receipt.entry.alternate_uri}"    
    puts "deposit_receipt.entry.media_entry_uri:\t #{deposit_receipt.entry.media_entry_uri}"
    puts "deposit_receipt.entry.media_resource_links:\t #{deposit_receipt.entry.media_resource_links}"
    puts "deposit_receipt.entry.sword_edit_uri:\t #{deposit_receipt.entry.sword_edit_uri}"
    puts "deposit_receipt.entry.sword_original_deposit_uri:\t #{deposit_receipt.entry.sword_original_deposit_uri}"
    puts "deposit_receipt.entry.sword_derived_resource_links:\t #{deposit_receipt.entry.sword_derived_resource_links}"
    puts "deposit_receipt.entry.sword_statement_links:\t #{deposit_receipt.entry.sword_statement_links}"
    puts "deposit_receipt.entry.sword_packagings:\t #{deposit_receipt.entry.sword_packagings}"
    puts "deposit_receipt.entry.sword_treatment:\t #{deposit_receipt.entry.sword_treatment}"
    puts "deposit_receipt.entry.sword_verbose_description:\t #{deposit_receipt.entry.sword_verbose_description}"
    puts "deposit_receipt.entry.dublin_core_extensions:\t #{deposit_receipt.entry.dublin_core_extensions}"
    puts "deposit_receipt.entry.dublin_core_extensions.first:\t #{deposit_receipt.entry.dublin_core_extensions.first}"    
    puts "\n"


    puts "\n"
    puts "creating a new entry (post binary file)"
    deposit_receipt = collection.post_media!("snowflake.png", "image/png", "http://purl.org/net/sword/package/METSDSpaceSIP")
    puts "deposit_receipt.entry.alternate_uri:\t #{deposit_receipt.entry.alternate_uri}"    
    puts "deposit_receipt.entry.media_entry_uri:\t #{deposit_receipt.entry.media_entry_uri}"
    puts "deposit_receipt.entry.media_resource_links:\t #{deposit_receipt.entry.media_resource_links}"
    puts "deposit_receipt.entry.sword_edit_uri:\t #{deposit_receipt.entry.sword_edit_uri}"
    puts "deposit_receipt.entry.sword_original_deposit_uri:\t #{deposit_receipt.entry.sword_original_deposit_uri}"
    puts "deposit_receipt.entry.sword_derived_resource_links:\t #{deposit_receipt.entry.sword_derived_resource_links}"
    puts "deposit_receipt.entry.sword_statement_links:\t #{deposit_receipt.entry.sword_statement_links}"
    puts "deposit_receipt.entry.sword_packagings:\t #{deposit_receipt.entry.sword_packagings}"
    puts "deposit_receipt.entry.sword_treatment:\t #{deposit_receipt.entry.sword_treatment}"
    puts "deposit_receipt.entry.sword_verbose_description:\t #{deposit_receipt.entry.sword_verbose_description}"
    puts "deposit_receipt.entry.dublin_core_extensions:\t #{deposit_receipt.entry.dublin_core_extensions}"
    puts "\n"
    

    puts "\n"
    puts "replacing an entry on a new deposit (put binary file)"
    success = deposit_receipt.entry.put_media!("questions_for_richard.txt", "text/plain", "http://purl.org/net/sword/package/METSDSpaceSIP")
    puts "success: #{success}"
    puts "\n"    
  
    

    puts "\n"
    puts "replacing meta data"
    deposit_receipt.entry.title="My New Title"
    success = deposit_receipt.entry.put!
    puts "success: #{success}"
    puts "\n"
    


    puts "\n"
    puts "creating a new entry (multipart post)"
    deposit_receipt = collection.post_multipart!(entry, "zip-test.zip", "application/zip", "http://purl.org/net/sword/package/METSDSpaceSIP")
    puts "deposit_receipt.entry.alternate_uri:\t #{deposit_receipt.entry.alternate_uri}"    
    puts "deposit_receipt.entry.media_entry_uri:\t #{deposit_receipt.entry.media_entry_uri}"
    puts "deposit_receipt.entry.media_resource_links:\t #{deposit_receipt.entry.media_resource_links}"
    puts "deposit_receipt.entry.sword_edit_uri:\t #{deposit_receipt.entry.sword_edit_uri}"
    puts "deposit_receipt.entry.sword_original_deposit_uri:\t #{deposit_receipt.entry.sword_original_deposit_uri}"
    puts "deposit_receipt.entry.sword_derived_resource_links:\t #{deposit_receipt.entry.sword_derived_resource_links}"
    puts "deposit_receipt.entry.sword_statement_links:\t #{deposit_receipt.entry.sword_statement_links}"
    puts "deposit_receipt.entry.sword_packagings:\t #{deposit_receipt.entry.sword_packagings}"
    puts "deposit_receipt.entry.sword_treatment:\t #{deposit_receipt.entry.sword_treatment}"
    puts "deposit_receipt.entry.sword_verbose_description:\t #{deposit_receipt.entry.sword_verbose_description}"
    puts "deposit_receipt.entry.dublin_core_extensions:\t #{deposit_receipt.entry.dublin_core_extensions}"
    puts "\n"


    puts "\n"
    puts "replacing meta data and binary data"
    deposit_receipt.entry.title="My New Title123456"
    success = deposit_receipt.entry.put_multipart!("questions_for_richard.txt", "text/plain", "http://purl.org/net/sword/package/METSDSpaceSIP")
    puts "success: #{success}"
    puts "\n"



    puts "\n"
    puts "deleting binary data"
    success = deposit_receipt.entry.delete_media!
    puts "success: #{success}"
    puts "\n"
    
    
    puts "\n"
    puts "adding binary data"
    deposit_receipt2 = deposit_receipt.entry.post_media!("questions_for_richard.txt", "text/plain", "http://purl.org/net/sword/package/METSDSpaceSIP")
    puts "deposit_receipt2: #{deposit_receipt2}"
    puts "\n"
    
    puts "\n"
    puts "adding more metadata to SE-URI data"
    deposit_receipt2 = deposit_receipt.entry.post!(entry)
    puts "deposit_receipt2: #{deposit_receipt2}"
    puts "\n"
    
      puts "\n"
      puts "adding more metadata and binary data to SE-URI data"
      deposit_receipt2 = deposit_receipt.entry.post_multipart!(entry, "questions_for_richard.txt", "text/plain", "http://purl.org/net/sword/package/METSDSpaceSIP")
      puts "deposit_receipt2: #{deposit_receipt2}"
      puts "\n"
    
    puts "\n"
    puts "deleting entry"
    success = deposit_receipt.entry.delete!
    puts "success: #{success}"
    puts "\n"




    
=begin        
    puts "printing feed attributes"
    puts "feed.entries.count: #{feed.entries.count}"
    puts "feed.links.count: #{feed.links.count}"
    puts "updating feed"
    

    
    feed.update!()
    puts "printing feed attributes"
    puts "feed.entries.count: #{feed.entries.count}"
    puts "feed.links.count: #{feed.links.count}"
    puts "entry.id: #{entry.id}"
    



    entry = feed.entries.first
    puts "entry.title: #{entry.title}"
    puts "entry.id: #{entry.id}"
    puts "entry.content: #{entry.content}"
    puts "entry.rights: #{entry.rights}"
    puts "entry.source: #{entry.source}"
    puts "entry.published: #{entry.published}"
    puts "entry.updated: #{entry.updated}"
    puts "entry.summary: #{entry.summary}"
    puts "entry.authors: #{entry.authors}"
=end
    
=begin    
#delete / insert    
    puts "now Delete entry from collection"
    collection.delete!(entry)
    puts "printing feed attributes"
    puts "feed.entries.count: #{feed.entries.count}"
    puts "feed.links.count: #{feed.links.count}"
    puts "updating feed"
    feed.update!
    puts "printing feed attributes"
    puts "feed.entries.count: #{feed.entries.count}"
    puts "feed.links.count: #{feed.links.count}"

=end
    
#    puts "now try and re-create entry by posting"
#    collection.post!(entry)
#    puts "printing feed attributes"
#    puts "feed.entries.count: #{feed.entries.count}"
#    puts "feed.links.count: #{feed.links.count}"
#    puts "updating feed"
#    feed.update!
#    puts "printing feed attributes"
#    puts "feed.entries.count: #{feed.entries.count}"
#    puts "feed.links.count: #{feed.links.count}"
    
    



#    puts "feed.entries = #{feed.entries}"
#    puts "feed.links = #{feed.links}"


  end
  
end


#    service = Sword2Ruby::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID);
#    service.refresh(TEST_CONNECTION_VALID);
#    service.service_document_uri.to_s.should eq TEST_SERVICE_DOCUMENT_URI_VALID;
#    service.repository_name.should eq TEST_REPOSITORY_NAME;
#    service.sword_version.should eq TEST_SWORD_VERSION;
#    service.collections.count.should eq TEST_COLLECTION_COUNT;
    
    
    #Now try and post to a collection
#    collection = service.collections[0]

#    collection = Sword2Ruby::Collection.new({:href=>"http://localhost:8080/col-uri/14661f1f-e625-4145-b477-2b08b757c6d7"})

 #   collection.create_resource(TEST_CONNECTION_VALID, {}, nil)


