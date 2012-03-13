#connection_spec.rb
require 'test_constants'


describe Sword2Ruby::Connection do
  
    it "initialise without parameters" do
      connection = Sword2Ruby::Connection.new()
      connection.user.should == nil
    end
  
    it "initialise with invalid parameters" do
      expect{Sword2Ruby::Connection.new(12345)}.to raise_error(ArgumentError);
    end
        
    it "try to retrieve malformed URI" do
      expect{TEST_CONNECTION_VALID.get(TEST_SERVICE_DOCUMENT_URI_MALFORMED)}.to raise_error(URI::InvalidURIError);
    end
    
    
end