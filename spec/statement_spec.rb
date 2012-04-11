#auto_discover_spec.rb
require "rexml/document"

require 'test_constants'


describe "Atom and RDF Statements" do
  
  it "Testing Atom Statement" do

    statement = Atom::Feed.new(TEST_ATOM_STATEMENT_URI, TEST_CONNECTION_VALID)
    statement.update!
    
    # there may or may not be media items associated with this statement
    statement.entries.count.should >= 0
    
    #The statement should have a category
    statement.sword_state_categories.count.should >= 1

    
    #If there are entries, loop through and validate each one
    statement.entries.each do |entry|
      entry.sword_packagings.count.should >= 1
      entry.sword_deposited_on.should_not be_nil
      entry.sword_deposited_by.should_not be_nil
      entry.sword_original_deposit_category.should_not be_nil
    end
  end


  it "Testing RDF OAI-ORE Statement" do
    statement = Sword2Ruby::SwordStatementOAIORE.new(TEST_RDF_STATEMENT_URI, TEST_CONNECTION_VALID)
    
    statement.rdf_descriptions.count.should >= 1
    
    # loop through and validate each description
    statement.rdf_descriptions.each do |description|

      #not much to validate as any of these could be nil
      puts "\n"
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