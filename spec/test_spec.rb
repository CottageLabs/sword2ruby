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

    
    puts "creating a new entry (post atom)"
    entry = feed.entries.new()
    entry.title = "Martyns new entry created on #{Time.now}"
    entry.summary = "This is a test"
    entry.updated = Time.now    
    receipt = collection.post!(entry)
    puts "receipt: #{receipt}"


    puts "creating a new entry (post binary file)"
    receipt = collection.post_media!(File.read("questions_for_richard.txt"), "questions_for_richard.txt", "text/plain", "http://purl.org/net/sword/package/METSDSpaceSIP")
    
    puts "receipt: #{receipt}"


    puts "receipt.code: #{receipt.code}"
    puts "receipt.message: #{receipt.message}"
#    receipt.each {|key, value| puts "#{key}\t=\t#{value}"}
    puts "receipt.body: #{receipt.body}"
    


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


#    puts "\nnow try with Sword2Ruby::Service"  
#    service = Sword2Ruby::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID);
#    service.refresh(TEST_CONNECTION_VALID);
#    puts "collections.count=#{service.collections.count}"
#    puts "workspaces.count=#{service.workspaces.count}"
#    puts "sword version = #{service.sword_version}"
#    puts "sword maxUpload = #{service.sword_max_upload_size}"
    
#    class Atom::Service
#      def sword_version
#        "hello world!"
#      end
#      def sword_max_upload_size
#        "boo!"
#      end
#    end
