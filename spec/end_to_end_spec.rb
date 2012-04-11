require 'test_constants'


  
  describe "End to End test for SimpleSwordServer" do

    #Define some variables
    current_service = nil
    current_collection = nil
    current_feed = nil
    current_slug = nil
    current_sword_edit_uri = nil
    current_entry_edit_uri = nil
    current_edit_media_uri = nil
    current_alternate_uri = nil
    current_sword_statement_links = nil

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
    end
    
    it "Create a new entry with an Atom post (no file)" do
      entry = Atom::Entry.new()
      entry.title = "Test Entry created by Sword2Ruby end-to-end test"
      entry.summary = "This entry was created during a test on #{Time.now}"
      entry.add_dublin_core_extension!("publisher", "Publisher Test 01")
      entry.add_dublin_core_extension!("audience", "Audience Test 01")
      entry.updated = Time.now
      
      #Generate a slug based on the date and time
      current_slug = "sword2ruby_test_#{Time.now.strftime("%FT%H-%M-%S")}"

      deposit_receipt = current_collection.post!(:entry=>entry, :slug=>current_slug, :in_progress=>true)
      current_feed.updated! #Flag feed that it has been updated
      
      #There SHOULD be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == true
      deposit_receipt.entry.should_not be_nil
      
      #There MAY be an alternate entry page
      current_alternate_uri = deposit_receipt.entry.alternate_uri
      
      #There MUST be an Atom Entry Edit / Media Entry / Edit-URI value
      current_entry_edit_uri = deposit_receipt.entry.entry_edit_uri
      current_entry_edit_uri.should_not be_nil
      
      #There MUST be at least one Edit Media Link / Media Resource URI / EM-URI
      edit_media_links = deposit_receipt.entry.edit_media_links
      edit_media_links.count.should >= 1
      current_edit_media_uri = edit_media_links.first.href

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
      current_sword_statement_links = deposit_receipt.entry.sword_statement_links
      current_sword_statement_links.count.should >= 0
      
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


    it "Test Entry.post" do
      #Now post a metadata update to the working entry
      update_entry = Atom::Entry.new()
      update_entry.title = "Extra title added to existing entry"
      update_entry.add_dublin_core_extension!("provenance", "Provenance Test 01")
      deposit_receipt = update_entry.post!(:sword_edit_uri => current_sword_edit_uri, :connection => TEST_CONNECTION_VALID)
            
      #There SHOULD be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == true
      deposit_receipt.entry.should_not be_nil

      #The updated entry should include the new Dublin Core provenance value
      Sword2Ruby::Utility.find_element_text(deposit_receipt.entry.dublin_core_extensions, "dcterms:provenance").should == "Provenance Test 01"
    
      #"Add a file to the existing entry via deposit receipt" do
      deposit_receipt.entry.post_media!(:filepath => "spec/fixtures/example.txt", :content_type=>"text/plain")
      #There SHOULD be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == true
      deposit_receipt.entry.should_not be_nil
    end
    
    it "Entry.post_media" do
      deposit_receipt = Atom::Entry.new().post_media!(:filepath => "spec/fixtures/snowflake.png", :content_type=>"image/png", :edit_media_uri => current_edit_media_uri, :connection => TEST_CONNECTION_VALID)
      
      #There SHOULD be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == true
      deposit_receipt.entry.should_not be_nil
    end
    
    
    it "Entry.post_multipart" do
        #Now post a metadata update to the working entry
        update_entry = Atom::Entry.new()
        update_entry.title = "Another extra title added to existing entry"
        update_entry.add_dublin_core_extension!("contributor", "Contributor 01")
        deposit_receipt = update_entry.post_multipart!(:sword_edit_uri => current_sword_edit_uri, :filepath => "spec/fixtures/snowflake.png", :content_type=>"image/png", :connection => TEST_CONNECTION_VALID)

        #There SHOULD be a deposit receipt entry received from the Sword server
        deposit_receipt.has_entry.should == true
        deposit_receipt.entry.should_not be_nil
      
      
        #The updated entry should include the new Dublin Core Contributor value
        Sword2Ruby::Utility.find_element_text(deposit_receipt.entry.dublin_core_extensions, "dcterms:contributor").should == "Contributor 01"
        #The updated entry should include the existing Dublin Core provenance value
        Sword2Ruby::Utility.find_element_text(deposit_receipt.entry.dublin_core_extensions, "dcterms:provenance").should == "Provenance Test 01"
    end
    
    it "Entry.put" do
      #Now PUT a metadata update to the working entry
      update_entry = Atom::Entry.new()
      update_entry.title = "Replaced Title"
      update_entry.add_dublin_core_extension!("contributor", "Contributor 02")
      deposit_receipt = update_entry.put!(:entry_edit_uri => current_entry_edit_uri, :connection => TEST_CONNECTION_VALID)

      #There SHOULD be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == true
      deposit_receipt.entry.should_not be_nil
    
    
      #The updated entry should include the updated Dublin Core Contributor value
      Sword2Ruby::Utility.find_element_text(deposit_receipt.entry.dublin_core_extensions, "dcterms:contributor").should == "Contributor 02"
      #The updated entry should have deleted the old provenance value
      Sword2Ruby::Utility.find_element_text(deposit_receipt.entry.dublin_core_extensions, "dcterms:provenance").should be_nil
    end
    
    it "Entry.put_media" do
      update_entry = Atom::Entry.new()
      deposit_receipt = update_entry.put_media!(:filepath => "spec/fixtures/snowflake.png", :content_type=>"image/png", :edit_media_uri => current_edit_media_uri, :connection => TEST_CONNECTION_VALID)

      #There ISN'T a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == false
      deposit_receipt.entry.should be_nil
    end

    it "Entry.put_multipart" do
      update_entry = Atom::Entry.new()
      update_entry.title = "Replaced Title"
      update_entry.add_dublin_core_extension!("contributor", "Contributor 03")
      deposit_receipt = update_entry.put_multipart!(:entry_edit_uri => current_entry_edit_uri, :filepath => "spec/fixtures/snowflake.png", :content_type=>"image/png", :connection => TEST_CONNECTION_VALID)

      #There SHOULD be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == true
      deposit_receipt.entry.should_not be_nil
      
      #The updated entry should include the updated Dublin Core Contributor value
      Sword2Ruby::Utility.find_element_text(deposit_receipt.entry.dublin_core_extensions, "dcterms:contributor").should == "Contributor 03"
      #The updated entry should have deleted the old provenance value
      Sword2Ruby::Utility.find_element_text(deposit_receipt.entry.dublin_core_extensions, "dcterms:provenance").should be_nil
    end
    
    it "AutoDiscover" do
      autodiscover = Sword2Ruby::AutoDiscover.new(current_alternate_uri)
      #Check the discovered entry edit uri matches the known entry edit uri
      autodiscover.entry_edit_uris.first[:href].should == current_entry_edit_uri
      
      #Check the discovered statement links count matches the known statement links count
      current_sword_statement_links.count.should == autodiscover.sword_statement_links.count
      
      #For each known statement link, check the href matches the discovered statement link
      current_sword_statement_links.each do |current|
        autodiscover.sword_statement_links.find{|discovered| discovered[:type] == current.type}[:href].should == current.href
      end      
    end
    

    it "Entry.delete_media" do
      update_entry = Atom::Entry.new()
      deposit_receipt = update_entry.delete_media!(:edit_media_uri => current_edit_media_uri, :connection => TEST_CONNECTION_VALID)
      
      #There SHOULD NOT be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == false
      deposit_receipt.entry.should be_nil
    end
    
    it "Entry.delete" do
      update_entry = Atom::Entry.new()
      deposit_receipt = update_entry.delete!(:entry_edit_uri => current_entry_edit_uri, :connection => TEST_CONNECTION_VALID)
      
      #There SHOULD NOT be a deposit receipt entry received from the Sword server
      deposit_receipt.has_entry.should == false
      deposit_receipt.entry.should be_nil
    end
    
 
end