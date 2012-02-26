#test_sepc.rb

require 'test_constants'
#require 'uri'

describe Sword2Ruby::Service do

  it "initialise without parameters" do
    expect{Sword2Ruby::Service.new()}.to raise_error(ArgumentError);
  end
  
  it "initialise with wrong URI type" do
    expect{Sword2Ruby::Service.new(nil, TEST_CONNECTION_VALID)}.to raise_error(ArgumentError);
  end
  
  it "initialise with wrong connection type" do
    expect{Sword2Ruby::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID, nil)}.to raise_error(ArgumentError);
  end
  
  it "initialise with invalid protocol URI" do
    expect{Sword2Ruby::Service.new(TEST_SERVICE_DOCUMENT_URI_INVALID_PROTOCOL, TEST_CONNECTION_VALID)}.to raise_error(URI::InvalidURIError);
  end
  
=begin
#  it "initialise with malformed URI" do
#    expect{Sword2Ruby::Connection.new(TEST_URI_MALFORMED)}.to raise_error(URI::InvalidURIError);
#  end
  
#  it "initialise with valid URI" do
#    connection = Sword2Ruby::Connection.new(TEST_URI_VALID)
#    connection.service_document_uri.to_s.should eq(TEST_URI_VALID)
#  end
  
 # it "initialise with valid URI and invalid Username/Password" 
  #do
  # expect{Sword2Ruby::Connection.new(TEST_URI_VALID, TEST_USERNAME_INVALID, TEST_PASSWORD_INVALID)}.to raise_error(HTTP::FIXME)
  #end
  
#  it "initialise with valid URI and valid Username/Password" 
  #do
    #connection = Sword2Ruby::Connection.new(TEST_URI_VALID, TEST_USERNAME_VALID, TEST_PASSWORD_VALID)
   # puts connection.getServiceDocument
  #end

 # it "test GetServiceDocument()"
#  it "test GetHistory()"



  it "Testing Invalid username/password" do
    service = Sword2Ruby::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID, TEST_CONNECTION_INVALID);
    
    service.service_document_uri.to_s.should eq TEST_SERVICE_DOCUMENT_URI_VALID;
    service.repository_name.should eq TEST_REPOSITORY_NAME;
    service.sword_version.should eq TEST_SWORD_VERSION;
    service.collections.count.should eq TEST_COLLECTION_COUNT;
  end
  
  
  it "Testing Valid Service" do
    service = Sword2Ruby::Service.new(SERVICE_DOCUMENT_URI, connection_valid);
    service.service_document_uri.to_s.should eq SERVICE_DOCUMENT_URI;
    service.repository_name.should eq REPOSITORY_NAME;
    service.sword_version.should eq SWORD_VERSION;
    service.collections.count.should eq COLLECTION_COUNT;
  end
=end
  
end