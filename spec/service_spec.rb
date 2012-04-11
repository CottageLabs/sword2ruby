#service_spec.rb

require 'test_constants'

describe ::Atom::Service do

  it "initialise without parameters" do
    expect{ Atom::Service.new()}.to raise_error(ArgumentError);
  end
  
  it "initialise with invalid URI type" do
    expect{ Atom::Service.new(123456)}.to raise_error(ArgumentError);
  end

  it "initialise with invalid URI protocol" do
    expect{ Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_INVALID_PROTOCOL)}.to raise_error(URI::InvalidURIError);
  end
  
  it "initialise with malformed URI" do
    expect{ Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_MALFORMED)}.to raise_error(URI::InvalidURIError);
  end
  
  it "initialise with valid URI, missing connection" do
    expect { Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID) }.to raise_error(Atom::Unauthorized)
  end

  it "initialise with valid URI, refresh with invalid username/password" do
    expect { Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID, TEST_CONNECTION_INVALID) }.to raise_error(Atom::Unauthorized)
  end

  
  it "initialise with valid URI, refresh with valid username/password" do
    service = ::Atom::Service.new(TEST_SERVICE_DOCUMENT_URI_VALID, TEST_CONNECTION_VALID)
    service.collections.count.should >= 1 #Test that the service has at least 1 collection 
  end

  
end