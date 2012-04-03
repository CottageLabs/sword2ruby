require 'test_constants'


  
  describe "End to End test for SimpleSwordServer" do

    #Define some variables
    service = nil
    collection = nil
    feed = nil
    slug = nil
  

    it "Retrieve Service Document" do
      service = Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID, TEST_CONNECTION_VALID);
      service.service_document_uri.should == TEST_SERVICE_DOCUMENT_URI_VALID
      service.sword_version.should == TEST_SWORD_VERSION
      service.sword_max_upload_size.should >= 0
      service.workspaces.count.should >= 1 #There should always be atleast 1 workspace
      service.collections.count.should >= 1 #There should always be atleast 1 collection
    end
    
    
    it "Retrieve the Collection" do
      collection = Sword2Ruby::Utility.find_element_by_href(service.collections, TEST_COLLECTION_HREF)

      if collection.nil?
        puts "\n-----\n"
        puts "ERROR:\tCould not find collection #{TEST_COLLECTION_HREF} in the service document (#{service.service_document_uri}).\n"
        puts "\tYou should check the value of TEST_COLLECTION_HREF in spec/test_constants.rb.\n"
        puts "\tHow about using TEST_COLLECTION_HREF=\"#{service.collections.first.href}\" instead?\n"
        puts "-----\n"
      end
      collection.should_not be_nil 
      collection.href.should == TEST_COLLECTION_HREF # Double check we have found the intended collection
    end
    
    it "Retrieve the Collection feed" do
      feed = collection.feed
      feed.update!
      feed.entries.count.should >= 0
    end
    
    it "Create a new entry with an Atom post (no file)" do
      entry = feed.entries.new()
      entry.title = "Test Entry created by Sword2Ruby end-to-end test"
      entry.summary = "This entry was created during a test on #{Time.now}"
      entry.add_dublin_core_extension!("publisher", "Sword2Ruby Test")
      entry.add_dublin_core_extension!("audience", "Sword2Ruby Tester")
      entry.updated = Time.now
      
      #Generate a slug based on the date and time
      slug = "sword2ruby_test_#{Time.now.strftime("%FT%H-%M-%S")}"

      deposit_receipt = collection.post!(entry, slug, true)
      
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
      sword_edit_uri = deposit_receipt.entry.sword_edit_uri
      sword_edit_uri.should_not be_nil
      
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
      entry = Atom::Entry.new()
      entry.title = "Extra metadata added to existing entry"
      puts "before feed.entries.count: #{feed.entries.count}"
      feed.update!
      puts "after feed.entries.count: #{feed.entries.count}"
      puts feed.entries
    end

end