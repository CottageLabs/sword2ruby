#auto_discover_spec.rb

require 'test_constants'


describe Sword2Ruby::AutoDiscover do
  
  it "Testing AutoDiscover on Service html" do
    autodiscover = Sword2Ruby::AutoDiscover.new(TEST_AUTODISCOVER_SERVICE_HTML_URI)

    #Test that the service_document_uri was found
    autodiscover.service_document_uri.should_not be_nil
  end

  it "Testing AutoDiscover on Collection html" do
    autodiscover = Sword2Ruby::AutoDiscover.new(TEST_AUTODISCOVER_COLLECTION_HTML_URI)
    
    #Test that the collection deposit_endpoint_uri was found
    autodiscover.deposit_endpoint_uri.should_not be_nil
  end
  
  it "Testing AutoDiscover on Entry html" do
    autodiscover = Sword2Ruby::AutoDiscover.new(TEST_AUTODISCOVER_ENTRY_HTML_URI)
    
    #Test that the collection deposit_endpoint_uri was found
    autodiscover.entry_edit_uris.count.should > 0
    autodiscover.sword_statement_links.count.should > 0
  end
  
end