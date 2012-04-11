#collection_spec.rb

require 'test_constants'

describe ::Atom::Collection do

  it "Get the test collection, post an entry to it" do
    current_collection = ::Atom::Collection.new(TEST_COLLECTION_HREF, TEST_CONNECTION_VALID)
    current_collection.should_not be_nil 
    current_collection.href.should == TEST_COLLECTION_HREF
    current_collection.collection_uri.should == TEST_COLLECTION_HREF
    
    current_feed = current_collection.feed
    current_feed.update!
    current_feed.entries.count.should >= 0
    
    entry = Atom::Entry.new()
    entry.title = "Test Entry created by Sword2Ruby Collection test"
    entry.summary = "This entry was created during a test on #{Time.now}"
    entry.updated = Time.now
      
    #Generate a slug based on the date and time
    current_slug = "sword2ruby_test_#{Time.now.strftime("%FT%H-%M-%S")}"

    deposit_receipt = current_collection.post!(:entry=>entry, :slug=>current_slug, :in_progress=>false)

    #There SHOULD be a deposit receipt entry received from the Sword server
    deposit_receipt.has_entry.should == true
    deposit_receipt.entry.should_not be_nil
    
  end
  
end