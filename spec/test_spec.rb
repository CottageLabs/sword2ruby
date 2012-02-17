#test_sepc.rb

require 'sword2ruby';

describe Sword2Ruby::Service do
  
  it "tst1" do
    
    user = Sword2Ruby::User.new('sword', 'sword')
    connection = Sword2Ruby::Connection.new(user)
    
    
    service = Sword2Ruby::Service.new('http://localhost:8080/sd-uri', connection)
    
    service.collections.count.should eq 10;
    puts "service.repository_name: #{service.repository_name}"
    puts "service.sword_version: #{service.sword_version}"
    puts "service.sword_max_upload_size: #{service.sword_max_upload_size}"
    
    puts service.collections
  end
  
end