#auto_discover_spec.rb

require 'test_constants'


describe Atom::Feed do
  
  it "Testing Atom Statement" do

    statement = Atom::Feed.new("http://localhost:8080/state-uri/14661f1f-e625-4145-b477-2b08b757c6d7/b3354f30-3830-4ad5-bf6e-f005d100638b.atom", TEST_CONNECTION_VALID)
    statement.update!
    
    puts statement
    
    puts "statement.entries: #{statement.entries}"
    
    statement.entries.each do |entry|
      
      #puts "entry: #{entry}"
      puts "entry.categories: #{entry.categories}"
      
      puts "entry.sword_packagings: #{entry.sword_packagings}"
      puts "entry.sword_deposited_on: #{entry.sword_deposited_on}"
      puts "entry.sword_deposited_by: #{entry.sword_deposited_by}"
      puts "entry.sword_deposited_on_behalf_of: #{entry.sword_deposited_on_behalf_of}"
    end
    
    
    
    
  end
end