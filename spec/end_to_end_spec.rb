require 'test_constants'


  
  describe "End to End test for SimpleSwordServer" do

    #Define some variables
    current_service = nil
    current_collection = nil
    current_feed = nil
    current_slug = nil
    current_sword_edit_uri = nil
  

    it "Retrieve Service Document" do
      current_service = Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID, TEST_CONNECTION_VALID);
      current_service.service_document_uri.should == TEST_SERVICE_DOCUMENT_URI_VALID
      current_service.sword_version.should == TEST_SWORD_VERSION
      current_service.sword_max_upload_size.should >= 0
      current_service.workspaces.count.should >= 1 #There should always be atleast 1 workspace
      current_service.collections.count.should >= 1 #There should always be atleast 1 collection
    end
    
    
    it "Retrieve the Collection" do
      current_collection = Sword2Ruby::Utility.find_element_by_href(current_service.collections, TEST_COLLECTION_HREF)

      if current_collection.nil?
        puts "\n-----\n"
        puts "ERROR:\tCould not find collection #{TEST_COLLECTION_HREF} in the service document (#{current_service.service_document_uri}).\n"
        puts "\tYou should check the value of TEST_COLLECTION_HREF in spec/test_constants.rb.\n"
        puts "\tHow about using TEST_COLLECTION_HREF=\"#{current_service.collections.first.href}\" instead?\n"
        puts "-----\n"
      end
      current_collection.should_not be_nil 
      current_collection.href.should == TEST_COLLECTION_HREF # Double check we have found the intended collection
    end
    
    it "Retrieve the Collection feed" do
      current_feed = current_collection.feed
      current_feed.update!
      current_feed.entries.count.should >= 0
      
      puts "before current_feed.entries.count: #{current_feed.entries.count}"
    end
    
    it "Create a new entry with an Atom post (no file)" do
      entry = Atom::Entry.new()
      entry.title = "Test Entry created by Sword2Ruby end-to-end test"
      entry.summary = "This entry was created during a test on #{Time.now}"
      entry.add_dublin_core_extension!("publisher", "Sword2Ruby Test")
      entry.add_dublin_core_extension!("audience", "Sword2Ruby Tester")
      entry.updated = Time.now
      
      #Generate a slug based on the date and time
      current_slug = "sword2ruby_test_#{Time.now.strftime("%FT%H-%M-%S")}"

      deposit_receipt = current_collection.post!(:entry=>entry, :slug=>current_slug, :in_progress=>true)
      current_feed.updated! #Flag feed that it has been updated
      
      #There SHOULD be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == true
      deposit_receipt.entry.should_not be_nil
      
      #There MAY be an alternate entry page
      alternate_uri = deposit_receipt.entry.alternate_uri
      
      #There MUST be an Atom Entry Edit / Media Entry / Edit-URI value
      entry_edit_uri = deposit_receipt.entry.entry_edit_uri
      entry_edit_uri.should_not be_nil
      
      #There MUST be at least one Edit Media Link / Media Resource URI / EM-URI
      edit_media_links = deposit_receipt.entry.edit_media_links
      edit_media_links.count.should >= 1

      #There MUST be a Sword Edit URI / SE-URI
      current_sword_edit_uri = deposit_receipt.entry.sword_edit_uri
      current_sword_edit_uri.should_not be_nil
      
      #There SHOULD be a single original deposit link - EXCEPT in this case we have not deposited a file, so it SHOULD be nil
      sword_original_deposit_uri = deposit_receipt.entry.sword_original_deposit_uri
      sword_original_deposit_uri.should be_nil
      
      #There SHOULD be zero or more derived resources - EXCEPT in this case, so it SHOULD be an empty array []
      sword_derived_resource_links = deposit_receipt.entry.sword_derived_resource_links
      sword_derived_resource_links.count.should == 0
      
      #There MAY be one or more links to Sword statements
      sword_statement_links = deposit_receipt.entry.sword_statement_links
      sword_statement_links.count.should >= 0
      
      #There MAY be some sword packagings
      sword_packagings = deposit_receipt.entry.sword_packagings
      sword_packagings.count.should >= 0
      
      #There MUST be a sword treatment
      sword_treatment = deposit_receipt.entry.sword_treatment
      sword_treatment.should_not be_nil
      
      #There MAY be a verbose description
      sword_verbose_description = deposit_receipt.entry.sword_verbose_description

      #There MAY be dublin core metadata
      dublin_core_extensions = deposit_receipt.entry.dublin_core_extensions
    end


    it "Add more meta data to existing entry" do
      #Now post a metadata update to the working entry
      update_entry = Atom::Entry.new()
      update_entry.title = "Extra title added to existing entry"
      update_entry.add_dublin_core_extension!("provenance", "Extra Sword2Ruby Provenance")
#      update_entry.post!(update_entry, current_sword_edit_uri, true, nil, TEST_CONNECTION_VALID)
      update_entry.post!(:sword_edit_uri => current_sword_edit_uri, :connection => TEST_CONNECTION_VALID) 
      
      #, current_sword_edit_uri, true, nil, TEST_CONNECTION_VALID)




#      current_feed.update!
      #Find the entry created in the previous step using the slug as the identifier
#      working_entry = current_feed.entries.find{|e| e.id.end_with?(current_slug)}
#      working_entry.should_not be_nil
      
      #tests
#      puts "working_entry.sword_edit_uri: #{working_entry.sword_edit_uri}"
#      puts "working_entry: #{working_entry}"
      
      

 #     current_feed.updated! #Flag feed that it has been updated
      
  #    current_feed.update!

      


      #puts "working_entry: #{working_entry}"
      
#      puts "current_feed.entries: #{current_feed.entries}"
      
#      puts "after current_feed.entries.count: #{current_feed.entries.count}"
      #puts current_feed.entries
    end

end