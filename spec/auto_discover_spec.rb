#auto_discover_spec.rb

require 'test_constants'


describe Sword2Ruby::AutoDiscover do
  
  it "Testing AutoDiscover" do
    discover = Sword2Ruby::AutoDiscover.new("http://localhost:8080/")
    puts "discover.service_document_uri: #{discover.service_document_uri}"
    puts "discover.deposit_endpoint_uri: #{discover.deposit_endpoint_uri}"
    puts "discover.resource_edit_uris: #{discover.resource_edit_uris}"
    puts "discover.resource_statement_uris: #{discover.resource_statement_uris}"

    discover = Sword2Ruby::AutoDiscover.new("http://localhost:8080/html/14661f1f-e625-4145-b477-2b08b757c6d7")
    puts "discover.service_document_uri: #{discover.service_document_uri}"
    puts "discover.deposit_endpoint_uri: #{discover.deposit_endpoint_uri}"
    puts "discover.resource_edit_uris: #{discover.resource_edit_uris}"
    puts "discover.resource_statement_uris: #{discover.resource_statement_uris}"


    discover = Sword2Ruby::AutoDiscover.new("http://localhost:8080/html/14661f1f-e625-4145-b477-2b08b757c6d7/02a7bdfa-ca4b-4aa4-88e5-379d22ee5bb1")
    puts "discover.service_document_uri: #{discover.service_document_uri}"
    puts "discover.deposit_endpoint_uri: #{discover.deposit_endpoint_uri}"
    puts "discover.resource_edit_uris: #{discover.resource_edit_uris}"
    puts "discover.resource_statement_uris: #{discover.resource_statement_uris}"

    
  end
end