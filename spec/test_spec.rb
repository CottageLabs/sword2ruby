#test_sepc.rb

require 'sword2ruby';

describe Sword2Ruby::Service do

#  user = Sword2Ruby::User.new(USERNAME_VALID, PASSWORD_VALID)
#  connection = Sword2Ruby::Connection.new(user)
  
  
  it "Testing Service" do
    service = Sword2Ruby::Service.new(SERVICE_DOCUMENT_URI, connection);
    service.service_document_uri.to_s.should eq SERVICE_DOCUMENT_URI;
    service.repository_name.should eq REPOSITORY_NAME;
    service.sword_version.should eq SWORD_VERSION;
    service.collections.count.should eq COLLECTION_COUNT;
  end
  
end