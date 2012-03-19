#deposit_receipt.rb


module Sword2Ruby
  class DepositReceipt
    
    attr_reader :has_entry, :entry, :location, :status_code, :status_message
    
    def initialize(response, http)
      @location = response.header["location"]
      @status_code = response.code
      @status_message = response.message
            
      if response.body
        #If a receipt was returned, parse it
        @entry = Atom::Entry.parse(response.body)
        @entry.http = http
        @has_entry = true
      else
        #if the receipt was not returned, try and retrieve it
        if @location
          @entry = Atom::Entry.parse(http.get(@location).body)
          @has_entry = true
        else
          #Otherwise, there is no receipt (e.g. for a delete)
          @has_entry = false
          @entry = nil
        end
      end
    end
    
  end
end