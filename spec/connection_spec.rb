#connection_sepc.rb
require 'sword2ruby';

TEST_URI_VALID = 'http://localhost:8080/sd-uri';
TEST_URI_INVALID_PROTOCOL = 'ftp://example.org/service-doc'
TEST_URI_MALFORMED = 'http: this is wrong';

TEST_USERNAME_VALID = 'sword';
TEST_PASSWORD_VALID = 'sword';
TEST_USERNAME_INVALID = 'testuser-invalid';
TEST_PASSWORD_INVALID = 'testpass-invalid';


describe Sword2Ruby::Connection do
  
    it "initialise without parameters" do
      expect{Sword2Ruby::Connection.new}.to raise_error(ArgumentError);
    end
  
    it "initialise with invalid protocol URI" do
      expect{Sword2Ruby::Connection.new(TEST_URI_INVALID_PROTOCOL)}.to raise_error(URI::InvalidURIError);
    end
    
    it "initialise with malformed URI" do
      expect{Sword2Ruby::Connection.new(TEST_URI_MALFORMED)}.to raise_error(URI::InvalidURIError);
    end
    
    it "initialise with valid URI" do
      connection = Sword2Ruby::Connection.new(TEST_URI_VALID)
      connection.service_document_uri.to_s.should eq(TEST_URI_VALID)
    end
    
    it "initialise with valid URI and invalid Username/Password" do
      expect{Sword2Ruby::Connection.new(TEST_URI_VALID, TEST_USERNAME_INVALID, TEST_PASSWORD_INVALID)}.to raise_error(HTTP::FIXME)
    end
    
    it "initialise with valid URI and valid Username/Password" do
      connection = Sword2Ruby::Connection.new(TEST_URI_VALID, TEST_USERNAME_VALID, TEST_PASSWORD_VALID)
      puts connection.getServiceDocument
    end

    it "test GetServiceDocument()"
    it "test GetHistory()"
    
end