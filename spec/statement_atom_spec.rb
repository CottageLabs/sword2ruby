#auto_discover_spec.rb
require "rexml/document"

require 'test_constants'


describe Atom::Feed do
  
  it "Testing Atom Statement" do

    statement = Atom::Feed.new("http://localhost:8080/state-uri/14661f1f-e625-4145-b477-2b08b757c6d7/b3354f30-3830-4ad5-bf6e-f005d100638b.atom", TEST_CONNECTION_VALID)
    statement.update!
    
    puts statement
    
    puts "\n"
    
    puts "statement.entries: #{statement.entries}"
        
    puts "statement.sword_state_categories: #{statement.sword_state_categories}"
    puts "statement.sword_state: #{statement.sword_state}"
    puts "statement.sword_state_description: #{statement.sword_state_description}" 

    statement.entries.each do |entry|
      
      #puts "entry: #{entry}"
      puts "entry.sword_packagings: #{entry.sword_packagings}"
      puts "entry.sword_deposited_on: #{entry.sword_deposited_on}"
      puts "entry.sword_deposited_by: #{entry.sword_deposited_by}"
      puts "entry.sword_deposited_on_behalf_of: #{entry.sword_deposited_on_behalf_of}"
      
      puts "entry.sword_original_deposit_category: #{entry.sword_original_deposit_category}"
    end
    
    
    ### Now test RDF reader
    puts "\nNow testing RDF"
    
    statement = Sword2Ruby::SwordStatement.new("http://localhost:8080/state-uri/14661f1f-e625-4145-b477-2b08b757c6d7/b3354f30-3830-4ad5-bf6e-f005d100638b.rdf", TEST_CONNECTION_VALID)
    
    #puts "statement.rdf_descriptions: #{statement.rdf_descriptions}"
   
    # puts "statement.sword_deposited_on_behalf_of: #{statement.sword_deposited_on_behalf_of}"
    
      puts "\n"    
    statement.rdf_descriptions.each do |description|
      #puts "description: #{description}"
      puts "description: #{description.rdf_about}"
      puts "    description.sword_packagings: #{description.sword_packagings}"
      puts "    description.sword_deposited_on: #{description.sword_deposited_on}"
      puts "    description.sword_deposited_by: #{description.sword_deposited_by}"
      puts "    description.sword_deposited_on_behalf_of: #{description.sword_deposited_on_behalf_of}"
      
      puts "    description.sword_original_deposit: #{description.sword_original_deposit}"
      puts "    description.sword_state: #{description.sword_state}" 
      puts "    description.sword_state_description: #{description.sword_state_description}" 
      puts "\n"
      
      
    end
   
    
    
  end
end