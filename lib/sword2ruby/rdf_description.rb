#rdf_description.rb

require 'rexml/element'

module Sword2Ruby

  class  REXML::Element
    
    #Overloads for Element

     def rdf_about
       self.attributes["rdf:about"]
     end
     
     def sword_packagings
       Utility.find_elements_attribute_value(self.elements, "sword:packaging", "rdf:resource")
     end

     def sword_original_deposit
       Utility.find_element_attribute_value(self.elements, "sword:originalDeposit", "rdf:resource")
     end

     def sword_deposited_on
       Utility.find_element_time(self.elements, "sword:depositedOn")
     end
     
     def sword_deposited_by
       Utility.find_element_text(self.elements, "sword:depositedBy")
     end

     def sword_deposited_on_behalf_of
       Utility.find_element_text(self.elements, "sword:depositedOnBehalfOf")
     end
     
     def sword_state
       Utility.find_element_attribute_value(self.elements, "sword:state", "rdf:resource")
     end

     def sword_state_description
       Utility.find_element_text(self.elements, "sword:stateDescription")
     end



  end

end