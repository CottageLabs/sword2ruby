#sword_statement.rb


require 'rexml/document'

module Sword2Ruby
  class SwordStatement
    
    attr_reader :statement_document, :rdf_descriptions
    
    def initialize(sword_statement_uri, connection)
      response = connection.get(sword_statement_uri)

      if response.is_a? Net::HTTPSuccess
         @statement_document = REXML::Document.new(response.body)
         @rdf_descriptions = []
         @statement_document.elements.each("/rdf:RDF/rdf:Description") do |description|
           
           def description.rdf_about
             self.attributes["rdf:about"]
           end
           
           def description.sword_packagings
             Utility.find_elements_attribute_value(self.elements, "sword:packaging", "rdf:resource")
           end

           def description.sword_original_deposit
             Utility.find_element_attribute_value(self.elements, "sword:originalDeposit", "rdf:resource")
           end

           def description.sword_deposited_on
             Utility.find_element_time(self.elements, "sword:depositedOn")
           end
           
           def description.sword_deposited_by
             Utility.find_element_text(self.elements, "sword:depositedBy")
           end

           def description.sword_deposited_on_behalf_of
             Utility.find_element_text(self.elements, "sword:depositedOnBehalfOf")
           end
           
           def description.sword_state
             Utility.find_element_attribute_value(self.elements, "sword:state", "rdf:resource")
           end

           def description.sword_state_description
             Utility.find_element_text(self.elements, "sword:stateDescription")
           end
           
           
             
           @rdf_descriptions << description
         end

         puts @statement_document
         
       else
         raise Sword2Ruby::Exception.new("Failed to do get(): server returned code #{response.code} #{response.message}")   
      end
    end
    
  end
end